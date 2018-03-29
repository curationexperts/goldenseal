class Video < ResourceBase
  include WithTEI

  def self.indexer
    BaseWorkIndexer
  end
end
