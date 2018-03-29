class Image < ResourceBase 
  def self.indexer
    ImageIndexer
  end
end
