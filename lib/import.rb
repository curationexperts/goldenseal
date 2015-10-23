module Import
  extend ActiveSupport::Autoload
  autoload :FileWithName
  autoload :ParseTei
  autoload :Rights

  autoload :CommonXmlParser
  autoload :TextTeiParser
  autoload :VideoTeiParser
  autoload :AudioTeiParser
  autoload :ImageVraParser

  autoload :CommonImporter
  autoload :TextImporter
  autoload :VideoImporter
  autoload :AudioImporter
  autoload :ImageImporter
end
