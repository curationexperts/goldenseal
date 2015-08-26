require 'rails_helper'

describe CurationConcerns::TextsController do
  describe "show" do
    let(:conn) { ActiveFedora::SolrService.instance.conn }
    before do
      conn.add id: "1j92g7448", "has_model_ssim" => ['Text'], 'read_access_group_ssim' => ['public']
      conn.commit
      sign_in create(:user)
    end

    it "is successful" do
      get :show, id: "1j92g7448"

      expect(response).to be_successful
      expect(assigns[:presenter]).to be_kind_of TextPresenter
    end
  end
end
