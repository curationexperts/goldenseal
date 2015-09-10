require 'rails_helper'

describe 'Visit the show page for a record:' do
  let(:attrs) {{ title: ['Front Cover Image'],
                 identifier: ['ident 123']
  }}

  let(:image) { create(:image, :public, attrs) }

  it 'displays the record correctly' do
    visit curation_concerns_image_path(image)

    expect(page).to have_content(attrs[:title].first)
    expect(page).to have_content(attrs[:identifier].first)
  end
end
