module OptionsHelper
  def tei_select_options(object)
    xml_files(object).map do |file|
      label = file.label || file.to_s || file.id
      [label, file.id]
    end
  end

  private

    def xml_files(object)
      object.generic_files.select do |file|
        xml_mime_type = ['application/xml', 'text/xml'].include?(file.mime_type)
        file_name = file.original_file && file.original_file.original_name
        xml_extension = file_name && File.extname(file_name) == '.xml'
        xml_mime_type || xml_extension
      end
    end
end
