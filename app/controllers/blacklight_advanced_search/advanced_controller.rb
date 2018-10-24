class BlacklightAdvancedSearch::AdvancedController < CatalogController
  include Hydra::Controller::SearchBuilder

  def index
    unless request.method==:post
      @response = get_advanced_search_facets
    end
  end

  protected
  def get_advanced_search_facets
    # We want to find the facets available for the current search, but:
    # * IGNORING current query (add in facets_for_advanced_search_form filter)
    # * IGNORING current advanced search facets (remove add_advanced_search_to_solr filter)
    response, _ = search_results(params, search_params_logic) do |search_builder|
      search_builder.except(:add_advanced_search_to_solr).append(:facets_for_advanced_search_form)
      search_builder.current_ability = current_ability
      search_builder
    end

    return response
  end
end
