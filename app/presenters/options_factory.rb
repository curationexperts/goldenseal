class OptionsFactory

  def initialize(object)
    @object = object
  end

  def xml_options
    file_sets(['application/xml', 'text/xml']).map do |file|
      [file.title_or_label, file.id]
    end
  end

  private

    # @return [Array<SolrDocument>] a list of solr documents in no particular order
    def file_sets(mime_types)
      q = "_query_:\"{!terms f=id}#{@object.member_ids.join(',')}\" AND " \
        "_query_:\"{!terms f=mime_type_ssi}#{mime_types.join(',')}\""
      query(q, rows: 1000).map { |res| SolrDocument.new(res) }
    end

    # Query solr using POST so that the query doesn't get too large for a URI
    def query(query, args = {})
      args.merge!(q: query, qt: 'standard')
      conn = ActiveFedora::SolrService.instance.conn
      result = conn.post('select', data: args)
      result.fetch('response').fetch('docs')
    end
end
