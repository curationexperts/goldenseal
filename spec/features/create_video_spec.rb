require 'rails_helper'

describe 'Creating a Work' do
  let(:user) { User.create(username: 'videomaker', group_list: ["admin"]) }

  before do
    stub_out_redis
    ActiveFedora::Cleaner.clean!
    login_as user
  end

  let(:tei_name) { 'hello.pdf' }
  let(:video_name) { 'add14885.01250.032.xml' }
  let(:thumb_name) { 'bull_ru_ku_001_015_0015.jp2' }
  let(:title) { 'Video Title' }

  it 'attaches the files' do
    visit new_curation_concerns_video_path
    fill_in 'Title', with: title
    attach_file('Transcript', File.join(fixture_path, tei_name))
    attach_file('Main media', File.join(fixture_path, 'video_importer', video_name))
    attach_file('Thumbnail', File.join(fixture_path, 'image_importer', thumb_name))

    click_on('Create Video')
    expect(page).to have_content(title)

    # Verify the files are set properly
    work = Video.first
    expect(work.tei.label).to eq tei_name
    expect(work.representative.label).to eq video_name
    expect(work.thumbnail.label).to eq thumb_name
  end
end
