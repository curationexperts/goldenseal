module WithTEI
  extend ActiveSupport::Concern

  included do
    belongs_to :tei, predicate: ::RDF::URI('http://opaquenamespace.org/ns/hasEncodedText'), class_name: 'GenericFile'

    before_save :assign_default_tei
  end

  # if tei isn't set and there are generic_files, then set the first one
  def assign_default_tei
    unless tei_id || generic_file_ids.empty?
      self.tei_id = generic_file_ids.first
    end
  end
end
