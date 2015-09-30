require 'rails_helper'

describe 'Searching the catalog:' do
  describe 'search all fields for the word "blue"' do
    before { ActiveFedora::Cleaner.clean! }

    let(:non_blue_fields) {{ title: ['Some Title'],
                             contributor: ['Some Contrib'],
                             description: ['Some desc'] }}

    let!(:not_blue) { create(:image, :public, non_blue_fields) }
    let!(:blue_title) { create(:image, :public, non_blue_fields.merge(title: ['Blue Whales'])) }
    let!(:blue_contrib) { create(:image, :public, non_blue_fields.merge(contributor: ['John Blue'])) }
    let!(:blue_desc) { create(:image, :public, non_blue_fields.merge(description: ['yellow and blue make green'])) }
    let!(:blue_id) { create(:image, :public, non_blue_fields.merge(id: 'blue')) }
    let!(:blue_sub) { create(:image, :public, non_blue_fields.merge(subject: ['blue'])) }

    it 'the search results show all the matches' do
      # Catalog page should show all objects
      visit catalog_index_path
      expect(page).to have_selector('#documents .document', count: 6)

      # Search for "blue"
      fill_in 'q', with: 'blue'
      find(:css, '#keyword-search-submit').click

      # It shouldn't have non-matching results
      expect(page).to_not have_link(not_blue.title.first, href: curation_concerns_image_path(not_blue))

      # It should show only the correct search results
      expect(page).to have_link(blue_title.title.first, href: curation_concerns_image_path(blue_title))
      expect(page).to have_link(blue_contrib.title.first, href: curation_concerns_image_path(blue_contrib))
      expect(page).to have_link(blue_desc.title.first, href: curation_concerns_image_path(blue_desc))
      expect(page).to have_link(blue_id.title.first, href: curation_concerns_image_path(blue_id))
      expect(page).to have_link(blue_sub.title.first, href: curation_concerns_image_path(blue_sub))

      expect(page).to have_selector('#documents .document', count: 5)
    end
  end
end
