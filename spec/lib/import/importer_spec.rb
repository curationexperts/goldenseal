require 'rails_helper'
require 'import'

describe Import::Importer do
  let(:lew_file) { File.join(fixture_path, 'dlxs', 'short-lew-dc.xml') }

  describe 'inititialize' do
    subject { described_class.new(type, file) }

    context 'with correct inputs' do
      let(:type) { 'text' }
      let(:file) { lew_file }

      it 'sets work type and DC metadata file' do
        expect(subject.work_type).to eq Text
        expect(subject.dc_file).to eq lew_file
      end
    end

    context 'with bad model input' do
      let(:type) { 'bad input' }
      let(:file) { lew_file }

      it 'raises an error' do
        expect{ subject }.to raise_error(InvalidWorkTypeError, 'Invalid work type: bad input')
      end
    end
  end


  describe '#run' do
    subject { described_class.new(type, file).run }

    let(:id_1) { 'lew1873.0001.003' }
    let(:id_2) { 'lew1880.0001.008' }

    context "when the records don't exist yet" do
      let(:type) { 'text' }
      let(:file) { lew_file }

      before do
        [id_1, id_2].each do |id|
          next unless ActiveFedora::Base.exists?(id)
          ActiveFedora::Base.find(id).destroy(eradicate: true)
        end
      end

      it 'creates the records' do
        expect { subject }.to change { Text.count }.by(2)
        expect(subject).to eq 2

        text_1 = Text.find(id_1)
        expect(text_1.title).to eq ['Die Erlöserin.']

        text_2 = Text.find(id_2)
        expect(text_2.title).to eq ['Reisebriefe aus Deutschland, Italien und Frankreich (1877, 1878)']
      end
    end

    context "when the record already exists" do
      let(:type) { 'text' }
      let(:file) { lew_file }
      let(:old_title) { 'old title' }

      before do
        [id_1, id_2].each do |id|
          next unless ActiveFedora::Base.exists?(id)
          ActiveFedora::Base.find(id).destroy(eradicate: true)
        end

        # Existing record
        t1 = Text.new(id: id_1, title: [old_title], depositor: 'system', edit_users: ['system'])
        t1.save!
      end

      it "doesn't create a duplicate record" do
        expect { subject }.to change { Text.count }.by(1)
        expect(subject).to eq 2

        text_1 = Text.find(id_1)
        expect(text_1.title).to eq ['Die Erlöserin.']

        text_2 = Text.find(id_2)
        expect(text_2.title).to eq ['Reisebriefe aus Deutschland, Italien und Frankreich (1877, 1878)']
      end
    end

    context "when the metadata file can't be read" do
      let(:type) { 'text' }
      let(:file) { 'bad/file/path' }

      it 'raises an error' do
        expect{ subject }.to raise_error(/No such file or directory/)
      end
    end
  end  # describe run

end
