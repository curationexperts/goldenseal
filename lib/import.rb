module Import
  extend ActiveSupport::Autoload
  autoload :FileWithName

  autoload :CommonTeiParser
  autoload :TextTeiParser
  autoload :VideoTeiParser

  autoload :CommonImporter
  autoload :TextImporter
  autoload :VideoImporter
end
