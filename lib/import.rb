module Import
  extend ActiveSupport::Autoload
  autoload :FileWithName

  autoload :CommonTeiParser
  autoload :TextTeiParser
  autoload :VideoTeiParser
  autoload :AudioTeiParser

  autoload :CommonImporter
  autoload :TextImporter
  autoload :VideoImporter
  autoload :AudioImporter
end
