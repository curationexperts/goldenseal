require 'rails_helper'

describe CurationConcerns::ImagesController do
  let(:user) { create(:admin) }
  let(:admin_set) { create(:admin_set) }
  before { sign_in user }
  describe "#create" do
    it "creates Images" do
      expect {
        post :create, "image" => { "title" => ["A portrait"],
                                   "admin_set_id" => admin_set.id }
      }.to change { Image.count }.by(1)

      expect(assigns[:curation_concern].admin_set).to eq admin_set
    end
  end
end
