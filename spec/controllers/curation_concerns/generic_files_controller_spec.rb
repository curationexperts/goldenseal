require 'rails_helper'

describe CurationConcerns::GenericFilesController do
  let(:user) { create(:user) }

  describe "#show" do
    context "when vtt is requested" do
      before do
        sign_in user
        allow(VTTService).to receive(:create).with(String).and_return('transformed vtt')
      end

      let(:generic_file) { create(:tei_bearing_file, depositor: user) }

      it "is successful" do
        get :show, id: generic_file, format: :vtt
        expect(response).to be_successful
        expect(response.body).to eq 'transformed vtt'
      end
    end
  end
end
