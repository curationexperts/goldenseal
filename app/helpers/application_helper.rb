module ApplicationHelper

  def formatted_system_create(search_results)
    solr_doc = search_results.fetch(:document)
    nice_timestamp(solr_doc['system_create_dtsi'])
  end

  def formatted_system_modified(search_results)
    solr_doc = search_results.fetch(:document)
    nice_timestamp(solr_doc['system_modified_dtsi'])
  end

  def nice_timestamp(datetime)
    datetime.in_time_zone.strftime("%F %T %Z")
  end

end
