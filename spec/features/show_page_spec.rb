require 'rails_helper'

describe 'Visit the show page for a record:' do
  let(:attrs) {{ title: ['Front Cover Image'],
                 note: ['Note'],
                 extent: ['25 pages'],
                 date_issued: DateTime.parse('2015-01-02'),
                 identifier: ['ident 123'],
                 series: ['ser AAA'],
                 publication_place: ['NYC'],
                 editor: ['editor'],
                 sponsor: ['Company XYZ'],
                 funder: ['Fund Person 1'],
                 researcher: ['Some research team'],
                 description_standard: ['Some standard'],
  }}

  let(:image) { create(:image, :public, attrs) }

  it 'displays the record correctly' do
    visit curation_concerns_image_path(image)

    expect(page).to have_content(attrs[:title].first)
    expect(page).to have_content(attrs[:note].first)
    expect(page).to have_content('2015-01-02')
    expect(page).to have_content(attrs[:identifier].first)
    expect(page).to have_content(attrs[:series].first)
    expect(page).to have_content(attrs[:publication_place].first)
    expect(page).to have_content(attrs[:editor].first)
    expect(page).to have_content(attrs[:sponsor].first)
    expect(page).to have_content(attrs[:funder].first)
    expect(page).to have_content(attrs[:researcher].first)
    expect(page).to have_content(attrs[:description_standard].first)
    expect(page).to have_content(attrs[:extent].first)
  end
end
