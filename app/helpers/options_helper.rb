module OptionsHelper
  def tei_select_options(object)
    OptionsFactory.new(object).xml_options
  end
end
