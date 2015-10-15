require 'rails_helper'

describe 'admin_sets/show.html.erb' do
  let(:config) { CatalogController.blacklight_config }
  let(:attributes) do
    { id: '123',
      title_tesim: ['All the things'],
      has_model_ssim: ['AdminSet']
    }
  end
  let(:solr_doc) { SolrDocument.new(attributes) }

  before do
    assign(:presenter, AdminSetPresenter.new(solr_doc))
    allow(view).to receive(:blacklight_config).and_return(config)
    allow(view).to receive(:can?).and_return(true)
    expect(view).to receive(:render_thumbnail_tag).with(solr_doc)
    render
  end

  it "displays metadata" do
    expect(rendered).to have_selector 'span.label.label-danger', text: 'Private'
    expect(rendered).to have_link 'View Members', href: '/catalog?f%5Badmin_set_ssi%5D%5B%5D=All+the+things'
  end
end
