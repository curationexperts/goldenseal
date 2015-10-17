module WithTEI
  extend ActiveSupport::Concern

  included do
    belongs_to :tei, predicate: ::RDF::URI('http://data.press.net/ontology/asset/hasTranscript'), class_name: 'FileSet'

    before_save :assign_default_tei
  end

  # if tei isn't set and there are file_sets, then set the first one
  def assign_default_tei
    return if tei_id || file_set_ids.empty?
    self.tei_id = file_set_ids.first
  end
end
