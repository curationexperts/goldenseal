Spotlight::Engine.config.default_autocomplete_params = { 
  qf: 'id^1000 title_tesim^100 id_ng title_ng',
  facet: false,
  'facet.field' => [] 
}

Spotlight::Engine.config.thumbnail_field = "thumbnail_path_ss"
Spotlight::Engine.config.full_image_field = "thumbnail_path_ss"
