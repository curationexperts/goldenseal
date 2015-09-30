module Import
  class Importer
    attr_reader :work_type, :dc_file

    def initialize(work_type, dc_file)
      @work_type = work_type.capitalize.constantize
      @dc_file = dc_file
    rescue NameError
      raise InvalidWorkTypeError, "Invalid work type: #{work_type}"
    end

    def run
      metadata = DcXmlParser.new(dc_file).records
      metadata.inject(0) do |count, attributes|
        create_or_update_record(attributes)
        count + 1
      end
    end

    def create_or_update_record(attributes)
      destroy_record_if_exists(attributes[:id])

      work = work_type.new(attributes)
      work.depositor = 'system'
      work.edit_users += ['system']
      work.save!
    end

    def destroy_record_if_exists(id)
      return unless ActiveFedora::Base.exists?(id)
      ActiveFedora::Base.find(id).destroy(eradicate: true)
    end
  end
end
