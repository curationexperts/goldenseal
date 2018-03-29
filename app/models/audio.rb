class Audio < ResourceBase
  include WithTEI

  def self.indexer
    BaseWorkIndexer
  end
end
