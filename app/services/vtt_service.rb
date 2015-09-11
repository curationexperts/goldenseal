module VTTService
  # Convert a TEI transcript into WebVTT
  # @param [String] tei_xml the TEI to be converted
  def self.create(tei_xml)
    stylesheet.apply_to(Nokogiri::XML(tei_xml)).to_s
  end

  def self.stylesheet
    Nokogiri::XSLT(File.read(stylesheet_path))
  end

  def self.stylesheet_path
    'lib/xslt/transcript_tei_to_vtt.xslt'
  end
end
