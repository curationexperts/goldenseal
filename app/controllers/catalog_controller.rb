class CatalogController < ApplicationController
  include CurationConcerns::CatalogController

  def self.search_config
    super.merge('qf' => %w( title_tesim
                            contributor_tesim
                            description_tesim
                            subject_tesim
                            id ))
  end

  configure_blacklight do |config|
    config.search_builder_class = SearchBuilder

    ## Default parameters to send to solr for all search-like requests. See also SolrHelper#solr_search_params
    config.default_solr_params = {
      qf: search_config['qf'],
      qt: search_config['qt'],
      rows: search_config['rows']
    }

    # solr field configuration for search results/index views
    config.index.title_field = solr_name('title', :stored_searchable)
    config.index.display_type_field = solr_name('has_model', :symbol)

    config.index.thumbnail_field = 'thumbnail_path_ss'
    config.index.partials += [:action_menu]

    # solr field configuration for document/show views
    # config.show.title_field = solr_name("title", :stored_searchable)
    # config.show.display_type_field = solr_name("has_model", :symbol)

    # solr fields that will be treated as facets by the blacklight application
    #   The ordering of the field names is the order of the display
    config.add_facet_field solr_name('human_readable_type', :facetable)
    config.add_facet_field solr_name('creator', :facetable), limit: 5
    config.add_facet_field solr_name('tag', :facetable), limit: 10
    config.add_facet_field solr_name('subject', :facetable), limit: 10
    config.add_facet_field solr_name('language', :facetable)
    config.add_facet_field solr_name('based_near', :facetable), limit: 5
    config.add_facet_field solr_name('publisher', :facetable), limit: 5
    config.add_facet_field solr_name('file_format', :facetable), limit: 5
    config.add_facet_field 'admin_set_ssi', limit: 5
    config.add_facet_field 'generic_type_sim', show: false, single: true

    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    config.add_facet_fields_to_solr_request!

    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display
    config.add_index_field solr_name('description', :stored_searchable)
    config.add_index_field solr_name('tag', :stored_searchable)
    config.add_index_field solr_name('subject', :stored_searchable)
    config.add_index_field solr_name('creator', :stored_searchable)
    config.add_index_field solr_name('contributor', :stored_searchable)
    config.add_index_field solr_name('publisher', :stored_searchable)
    config.add_index_field solr_name('based_near', :stored_searchable)
    config.add_index_field solr_name('language', :stored_searchable)
    config.add_index_field uploaded_field, helper_method: :formatted_time, label: 'Date Uploaded'
    config.add_index_field modified_field, helper_method: :formatted_time, label: 'Date Modified'
    config.add_index_field 'date_issued_dtsi', helper_method: :formatted_time, label: 'Date Issued'
    config.add_index_field 'rights_label_ss', label: 'Content License'
    config.add_index_field solr_name('human_readable_type', :stored_searchable)
    config.add_index_field solr_name('format', :stored_searchable)

    # "fielded" search configuration. Used by pulldown among other places.
    # For supported keys in hash, see rdoc for Blacklight::SearchFields
    #
    # Search fields will inherit the :qt solr request handler from
    # config[:default_solr_parameters], OR can specify a different one
    # with a :qt key/value. Below examples inherit, except for subject
    # that specifies the same :qt as default for our own internal
    # testing purposes.
    #
    # The :key is what will be used to identify this BL search field internally,
    # as well as in URLs -- so changing it after deployment may break bookmarked
    # urls.  A display label will be automatically calculated from the :key,
    # or can be specified manually to be different.
    #
    # This one uses all the defaults set by the solr request handler. Which
    # solr request handler? The one set in config[:default_solr_parameters][:qt],
    # since we aren't specifying it otherwise.
    config.add_search_field('all_fields', label: 'All Fields', include_in_advanced_search: false)

    # Now we see how to over-ride Solr request handler defaults, in this
    # case for a BL "search field", which is really a dismax aggregate
    # of Solr search fields.
    # creator, title, description, publisher, date_created,
    # subject, language, resource_type, format, identifier, based_near,
    config.add_search_field('contributor') do |field|
      field.include_in_simple_select = false
      # solr_parameters hash are sent to Solr as ordinary url query params.

      # :solr_local_parameters will be sent using Solr LocalParams
      # syntax, as eg {! qf=$title_qf }. This is neccesary to use
      # Solr parameter de-referencing like $title_qf.
      # See: http://wiki.apache.org/solr/LocalParams
      solr_name = solr_name('contributor', :stored_searchable, type: :string)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('title') do |field|
      solr_name = solr_name('title', :stored_searchable, type: :string)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('creator') do |field|
      solr_name = solr_name('creator', :stored_searchable, type: :string)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('description') do |field|
      field.label = 'Description'
      solr_name = solr_name('description', :stored_searchable, type: :string)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('publisher') do |field|
      field.include_in_simple_select = false
      solr_name = solr_name('publisher', :stored_searchable, type: :string)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('date_created') do |field|
      field.include_in_simple_select = false
      solr_name = solr_name('created', :stored_searchable, type: :string)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('identifier') do |field|
      field.include_in_advanced_search = false
      solr_name = solr_name('id', :stored_searchable, type: :string)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('subject') do |field|
      solr_name = solr_name('subject', :stored_searchable, type: :string)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('language') do |field|
      field.include_in_simple_select = false
      solr_name = solr_name('language', :stored_searchable, type: :string)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('human_readable_type') do |field|
      field.include_in_simple_select = false
      solr_name = solr_name('human_readable_type', :stored_searchable, type: :string)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('format') do |field|
      field.include_in_simple_select = false
      field.include_in_advanced_search = false
      solr_name = solr_name('format', :stored_searchable, type: :string)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('based_near') do |field|
      field.include_in_simple_select = false
      field.label = 'Location'
      solr_name = solr_name('based_near', :stored_searchable, type: :string)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('tag') do |field|
      field.include_in_simple_select = false
      solr_name = solr_name('tag', :stored_searchable, type: :string)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('depositor') do |field|
      field.include_in_simple_select = false
      solr_name = solr_name('depositor', :stored_searchable, type: :string)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('rights') do |field|
      field.include_in_simple_select = false
      solr_name = solr_name('rights', :stored_searchable, type: :string)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('admin_set') do |field|
      field.include_in_simple_select = false
      solr_name = 'admin_set_ssi'
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the SOLR field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case).
    # label is key, solr field is value
    config.add_sort_field "score desc, #{uploaded_field} desc", label: "relevance \u25BC"
    config.add_sort_field "#{uploaded_field} desc", label: "time created \u25BC"
    config.add_sort_field "#{uploaded_field} asc", label: "time created \u25B2"
    config.add_sort_field "#{modified_field} desc", label: "time modified \u25BC"
    config.add_sort_field "#{modified_field} asc", label: "time modified \u25B2"

    # If there are more than this many search results, no spelling ("did you
    # mean") suggestion is offered.
    config.spell_max = 5
  end
end
