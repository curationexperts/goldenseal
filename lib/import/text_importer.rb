module Import
  # The results of running the importer.  Keep track of
  # errors, warnings, successful imports, or skipped imports.
  ImportResults = Struct.new(:errors, :warnings, :successful_imports, :skipped_imports)

  # Import Text records using data from TEI files.
  class TextImporter
    # The path to the directory where the TEI files are located
    attr_reader :tei_dir

    # The access rights visibility that will be applied
    attr_reader :visibility

    delegate :errors, :warnings, to: :status
    delegate :successful_imports, :skipped_imports, to: :status

    def initialize(dir, visibility=Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE)
      @tei_dir = dir
      @visibility = visibility
    end

    def status
      @status ||= ImportResults.new([], [], [], [])
    end

    # Parse all the TEI files that are found in the tei_dir,
    # and create a Text record for each one.
    def run
      tei_files.each { |tei| parse_tei(tei) }
      puts "\n" unless Rails.env.test?
    end

    def tei_files
      fail "Directory not found: #{tei_dir}" unless File.exist?(tei_dir)
      @tei_files ||= Dir.glob(File.join(tei_dir, '*.xml'))
    end

    # Parse one TEI file
    def parse_tei(tei)
      print '.' unless Rails.env.test?

      file_name = File.basename(tei)
      attrs = TextTeiParser.new(tei).attributes

      if attrs.blank?
        errors << "Failed to parse TEI file: #{file_name}"
      elsif record_exists?(attrs)
        # Don't re-import the record if this record already
        # exists in fedora.
        skipped_imports << file_name
      else
        create_record(attrs.merge(tei: file_name, visibility: visibility))
        successful_imports << file_name
      end
    rescue => e
      errors << "#{file_name}: #{e}"
    end

    def record_exists?(attrs)
      ident = attrs[:identifier]
      return false if ident.blank?
      fail "Unable to determine identifier for record: #{ident}" if ident.count > 1
      ident = ident.first

      existing_records = ActiveFedora::Base.where("identifier_tesim" => ident)
      fail "Too many matches found for record: #{ident}" if existing_records.count > 1

      existing_records.count == 1
    end

    def create_record(attributes)
      tei = attributes.delete(:tei)
      files = attributes.delete(:files) || []
      files.unshift(tei)

      attributes[:rights] = transform_rights(attributes) unless attributes[:rights].blank?

      record = Text.create!(attributes) do |r|
        r.apply_depositor_metadata(user)
      end

      create_files(record.id, tei, files)
    end

    # TODO: Should we loosen up the regex to include examples
    # like this?: "Court records fall within the public domain"
    def transform_rights(attrs)
      rr = 'http://www.europeana.eu/portal/rights/rr-r.html'.freeze
      pub_dom = 'http://creativecommons.org/publicdomain/mark/1.0/'.freeze

      rights = attrs[:rights].map do |rights_text|
        rights_text.match(/work is in the public domain/).nil? ? rr : pub_dom
      end
    end

    def create_files(record_id, tei, files)
      files.each do |file_name|
        matching_file = find_file(file_name, tei)
        next unless matching_file
        create_file(record_id, matching_file)
      end
    end

    def create_file(record_id, matching_file)
      file = FileWithName.new(matching_file)
      gf = FileSet.new
      actor = CurationConcerns::FileSetActor.new(gf, user)
      actor.create_metadata(nil, record_id)
      fail 'Content creation failed' unless actor.create_content(file)

      gf.errors.each { |k, v| errors << "GF #{k}: #{v}" }
      fail 'FileSet had errors' unless gf.errors.blank?
    end

    def find_file(file_name, tei)
      match = Dir.glob("#{tei_dir}/**/#{file_name}")

      if match.empty?
        warnings << "#{tei}: File not found: #{file_name}"
        nil
      elsif match.count != 1
        errors << "Unable to attach file.  More than one file was found with the same name: #{match.inspect}"
        nil
      else
        match.first
      end
    end

    # A "system" user to act as the depositor of the record
    def user
      @user ||= User.find_by_user_key('system')
      return @user if @user
      @user = User.create!(Devise.authentication_keys.first => 'system')
    end
  end
end
