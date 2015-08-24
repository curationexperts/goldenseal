Riiif::Image.file_resolver = Riiif::HTTPFileResolver.new
Riiif::Image.info_service = lambda do |id, file|
  ImageInfo.new(id).dimensions
end

Riiif::Image.file_resolver.id_to_uri = lambda do |id|
  Rails.cache.fetch("#{id}/original_file", expires_in: 3.months) do
    GenericFile.find(CGI.unescape(id)).original_file.uri
  end
end

Riiif::Image.file_resolver.basic_auth_credentials = [ActiveFedora.fedora.user, ActiveFedora.fedora.password]

Riiif::Engine.config.cache_duration_in_days = 365
