require 'rails_helper'

describe 'admin_sets/show.html.erb' do
  let(:attributes) do
    { id: '123',
      has_model_ssim: ['AdminSet']
    }
  end
  let(:solr_doc) { SolrDocument.new(attributes) }

  before do
    assign(:presenter, AdminSetPresenter.new(solr_doc))
    allow(view).to receive(:can?).and_return(true)
    render
  end

  it "displays metadata" do
    expect(rendered).to have_selector 'span.label.label-danger', text: 'Private'
  end
end
