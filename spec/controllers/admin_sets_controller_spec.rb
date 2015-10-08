require 'rails_helper'

describe AdminSetsController do
  describe "#new" do
    before { sign_in user }
    context "a non-admin" do
      let(:user) { create(:user) }
      it "redirects to home" do
        get :new
        expect(response).to redirect_to(root_path)
      end
    end

    context "an admin" do
      let(:user) { create(:admin) }
      it "is successful" do
        get :new
        expect(response).to be_successful
      end
    end
  end

  describe "#show" do
    before { sign_in user }
    let(:admin_set) { create(:admin_set) }
    context "a non-admin" do
      let(:user) { create(:user) }
      it "redirects to home" do
        get :show, id: admin_set
        expect(response).to be_successful
      end
    end

    context "an admin" do
      let(:user) { create(:admin) }
      it "is successful" do
        get :show, id: admin_set
        expect(response).to be_successful
      end
    end
  end

  describe "#create" do
    before { sign_in user }
    context "a non-admin" do
      let(:user) { create(:user) }
      it "redirects to home" do
        post :create, admin_set: { "title" => "Annie Leibovitz" }
        expect(response).to redirect_to(root_path)
      end
    end

    context "an admin" do
      let(:user) { create(:admin) }
      it "is successful" do
        expect {
          post :create, admin_set: { "title" => "Annie Leibovitz",
                                     "identifier" => "lei",
                                     "description" => "Pictures by Annie Leibovitz",
                                     "creator" => ["Mark Bussey"],
                                     "contributor" => ["Justin Coyne", "Valerie Maher"],
                                     "subject" => ["Portraiture"],
                                     "publisher" => ["Vanity Fair"],
                                     "language" => ["English"] }
        }.to change { AdminSet.count }.by(1)
        expect(response).to be_redirect
      end
    end
  end
end
