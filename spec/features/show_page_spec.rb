require 'rails_helper'

describe 'Visit the show page for a record:' do
  let(:attrs) {{ title: ['Front Cover Image'],
                 note: ['Note'],
                 date_issued: DateTime.parse('2015-01-02'),
                 identifier: ['ident 123'],
                 publication_place: ['NYC'],
                 editor: ['editor'],
                 sponsor: ['Company XYZ'],
  }}

  let(:image) { create(:image, :public, attrs) }

  it 'displays the record correctly' do
    visit curation_concerns_image_path(image)

    expect(page).to have_content(attrs[:title].first)
    expect(page).to have_content(attrs[:note].first)
    expect(page).to have_content('2015-01-02')
    expect(page).to have_content(attrs[:identifier].first)
    expect(page).to have_content(attrs[:publication_place].first)
    expect(page).to have_content(attrs[:editor].first)
    expect(page).to have_content(attrs[:sponsor].first)
  end
end
