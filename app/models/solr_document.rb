# -*- encoding : utf-8 -*-
class SolrDocument

  include Blacklight::Solr::Document
  # Adds CurationConcerns behaviors to the SolrDocument.
  include CurationConcerns::SolrDocumentBehavior
  # Do content negotiation for AF models.

  use_extension( Hydra::ContentNegotiation )

  def height
    self['height_is']
  end

  def width
    self['width_is']
  end

  def identifier
    self['identifier_tesim']
  end

  def series
    self['series_ssim']
  end

  def date_issued
    self['date_issued_dtsi']
  end

  def note
    self['note_tesim']
  end

  def extent
    self['extent_ssim']
  end

  def description_standard
    self['description_standard_ssim']
  end

  def publication_place
    self['publication_place_tesim']
  end

  def editor
    self['editor_tesim']
  end

  def sponsor
    self['sponsor_tesim']
  end

  def funder
    self['funder_tesim']
  end

  def researcher
    self['researcher_tesim']
  end

  def filename
    self['label_ssi']
  end
end
