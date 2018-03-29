module Spotlight
  ##
  # Exhibit resources
  class Resource < ActiveRecord::Base
    include Spotlight::SolrDocument::AtomicUpdates
    include ActiveSupport::Benchmarkable
    include Spotlight::Resources::GeneratingSolrDocuments 
    include Spotlight::Resources::Indexing

    extend ActiveModel::Callbacks
    define_model_callbacks :index

    class_attribute :weight

    belongs_to :exhibit
    serialize :data, Hash
    store :metadata, accessors: [
      :last_indexed_estimate,
      :last_indexed_count,
      :last_index_elapsed_time,
      :last_indexed_finished], coder: JSON

    enum index_status: [:waiting, :completed, :errored]

    around_index :reindex_with_logging
    after_index :commit
    after_index :completed!

    ##
    # Persist the record to the database, and trigger a reindex to solr
    #
    # @param [Hash] All arguments will be passed through to ActiveRecord's #save method
    def save_and_index(*args)
      save(*args) && reindex_later
    end

    ##
    # Enqueue an asynchronous reindexing job for this resource
    def reindex_later
      waiting!
      Spotlight::ReindexJob.perform_later(self)
    end

  end
end
