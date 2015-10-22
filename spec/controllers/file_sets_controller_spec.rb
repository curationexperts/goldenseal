require 'rails_helper'

describe CurationConcerns::FileSetsController do
  describe '#show_presenter' do
    subject { controller.send(:show_presenter) }
    it { is_expected.to eq ::FileSetPresenter }
  end
end
