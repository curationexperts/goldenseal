CurationConcerns.configure do |config|
  # Injected via `rails g curation_concerns:work Image`
  config.register_curation_concern :image
  # Injected via `rails g curation_concerns:work Document`
  config.register_curation_concern :document
end
