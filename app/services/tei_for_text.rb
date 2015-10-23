class TeiForText
  def initialize(text)
    @text = text
  end

  def to_json
    return unless tei
    as_json = TEIConverter.new(tei, @text).as_json
    return unless as_json
    JSON.generate(as_json)
  end

  private

    def tei
      @text.tei.try(:original_file).try(:content)
    end
end
