module Import
  class Rights

    def self.url_for(rights_string)
      return rr_url if rights_string.blank?

      if public_domain?(rights_string.squish.downcase)
        public_domain_url
      else
        rr_url
      end
    end

    # TODO: Should we loosen up the regex to include examples
    # like this?: "Court records fall within the public domain"
    def self.public_domain?(rights_string)
      rights_string == 'publicdomain' ||
        rights_string == 'public domain' ||
        rights_string.match(/work is in the public domain/)
    end

    def self.public_domain_url
      'http://creativecommons.org/publicdomain/mark/1.0/'.freeze
    end

    def self.rr_url
      'http://www.europeana.eu/portal/rights/rr-r.html'.freeze
    end

  end
end
