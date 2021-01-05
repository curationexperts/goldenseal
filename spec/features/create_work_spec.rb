require 'rails_helper'

describe 'Creating a Work' do
  let(:user) { User.create(username: 'create-work-test', group_list: ["admin"]) }

  before do
    stub_out_redis
    ActiveFedora::Cleaner.clean!
    login_as user
  end

  # Any files will do for this test, even if they are the wrong type.
  let(:tei_name) { 'hello.pdf' }
  let(:audio_name) { 'ccr1815.00757.018.xml' }
  let(:thumb_name) { 'bull_ru_ku_001_015_0015.jp2' }
  let(:title) { 'Some Kind of Title' }

  it 'attaches the files' do
    visit new_curation_concerns_audio_path
    fill_in 'Title', with: title
    attach_file('Transcript', File.join(fixture_path, tei_name))
    attach_file('Main media', File.join(fixture_path, 'tei', audio_name))
    attach_file('Thumbnail', File.join(fixture_path, 'image_importer', thumb_name))

    click_on('Create Audio')
    expect(page).to have_content(title)

    # Verify the files are set properly
    work = Audio.first
    expect(work.tei.label).to eq tei_name
    expect(work.representative.label).to eq audio_name
    expect(work.thumbnail.label).to eq thumb_name
  end
end
