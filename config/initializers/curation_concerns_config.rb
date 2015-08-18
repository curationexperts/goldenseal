CurationConcerns.configure do |config|
  # Injected via `rails g curation_concerns:work Document`
  config.register_curation_concern :audio
  config.register_curation_concern :document
  config.register_curation_concern :image
  config.register_curation_concern :video
end
