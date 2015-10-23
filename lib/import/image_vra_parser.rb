# Parse the VRA file for an image.
module Import
  class ImageVraParser < CommonXmlParser

    def namespaces
      { vra: "http://www.vraweb.org/vracore4.htm" }
    end

    # Map the name of the attribute to its xpath in the VRA file
    def xpath_map
      {
        title: '/vra:vra/vra:collection/vra:work/vra:image/vra:titleSet/vra:title',
        description: '/vra:vra/vra:collection/vra:work/vra:image/vra:relationSet/vra:display',
        contributor: '/vra:vra/vra:collection/vra:sourceSet/vra:source/vra:name',
        publisher: '/vra:vra/vra:collection/vra:locationSet/vra:location/vra:name[@type="other"]',
        extent: '/vra:vra/vra:collection/vra:work/vra:image/vra:measurementsSet'
      }
    end

  end
end
