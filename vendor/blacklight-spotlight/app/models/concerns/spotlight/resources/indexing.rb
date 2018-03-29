module Spotlight
  module Resources
    module Indexing
      extend ActiveSupport::Concern 

      ##
      # Index the result of {#to_solr} into the index in batches of {#batch_size}
      #
      # @return [Integer] number of records indexed
      def reindex
        benchmark "Reindexing #{self} (batch size: #{batch_size})" do
          count = 0

          run_callbacks :index do
            documents_to_index.each_slice(batch_size) do |batch|
              write_to_index(batch)
              update(last_indexed_count: (count += batch.length))
            end

            count
          end
        end
      end

      protected

      def reindex_with_logging
        time_start = Time.zone.now

        update(indexed_at: time_start,
               last_indexed_estimate: documents_to_index.size,
               last_indexed_finished: nil,
               last_index_elapsed_time: nil)

        count = yield

        time_end = Time.zone.now
        update(last_indexed_count: count,
               last_indexed_finished: time_end,
               last_index_elapsed_time: time_end - time_start)
      end

      private

      def blacklight_solr
        @solr ||= RSolr.connect(connection_config)
      end

      def connection_config
        Blacklight.connection_config
      end

      def batch_size
        Spotlight::Engine.config.solr_batch_size
      end

      def write_to_index(batch)
        return unless write?
        blacklight_solr.update params: { commitWithin: 500 },
                               data: batch.to_json,
                               headers: { 'Content-Type' => 'application/json' }
      end

      def commit
        return unless write?
        blacklight_solr.commit
      rescue => e
        Rails.logger.warn "Unable to commit to solr: #{e}"
      end
    end
  end
end
