module ApplicationHelper
  def formatted_time(search_results)
    datetime = search_results.fetch(:value)
    datetime.in_time_zone.strftime("%F %R %Z")
  end

  def index_description(options)
    config = options.fetch(:config)
    # In Blacklight 6 this will work:
    # value = presenter(options.fetch(:document)).render_values(options.fetch(:value), config)
    value = presenter(options.fetch(:document)).render_field_value(options.fetch(:value), config)
    length = config.fetch(:length)
    result = truncate value, length: length, separator: ' '
    if value.length > length
      result + link_to("Show full record", options.fetch(:document))
    else
      result
    end
  end

  def advanced_search_params 
    if params.keys.include?('f') && params['f'].keys.include?('admin_set_ssi')
      { f_inclusive: { admin_set_ssi: params['f']['admin_set_ssi']} }
    else 
      {}
    end
  end
end
