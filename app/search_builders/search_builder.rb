class SearchBuilder < CurationConcerns::SearchBuilder
  def collection_clauses
    return [] if blacklight_params.key?(:f) && Array(blacklight_params[:f][:generic_type_sim]).include?('Work')
    ["{!terms f=has_model_ssim}#{::Collection.to_class_uri},#{AdminSet.to_class_uri}"]
  end
end
