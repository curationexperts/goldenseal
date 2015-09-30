require 'rails_helper'

describe OptionsHelper do
  describe '#tei_select_options' do
    subject { helper.tei_select_options(obj) }

    context 'for a work with multiple files attached' do
      let(:id) { 'ccr1815.00757.018' }
      let(:xml_file_name) { 'ccr1815.00757.018.xml' }
      let(:pdf_file_name) { 'hello.pdf' }

      before do
        Text.find(id).destroy(eradicate: true) if Text.exists?(id)
      end

      let(:obj) do
        text = Text.new(id: id, title: ['test text']) do |t|
          t.apply_depositor_metadata('jcoyne')
        end
        text.members << xml_file
        text.members << pdf_file
        text.save!
        text
      end

      let(:xml_file) do
        generic_file = GenericFile.new do |gf|
          gf.apply_depositor_metadata('jcoyne')
          gf.mime_type = 'application/xml'
          gf.label = 'xml file'
        end
        file_path = File.join(fixture_path, 'tei', xml_file_name)
        Hydra::Works::AddFileToGenericFile.call(generic_file, File.open(file_path), :original_file)
        generic_file
      end

      let(:pdf_file) do
        generic_file = GenericFile.new do |gf|
          gf.apply_depositor_metadata('jcoyne')
          gf.mime_type = 'application/pdf'
          gf.label = 'pdf file'
        end
        file_path = File.join(fixture_path, pdf_file_name)
        Hydra::Works::AddFileToGenericFile.call(generic_file, File.open(file_path), :original_file)
        generic_file
      end

      it 'only returns XML files as options' do
        # Make sure the test is set up properly, with one XML
        # and one PDF file.
        expect(obj.generic_files.map(&:mime_type)).to eq ['application/xml', 'application/pdf']
        expect(subject).to eq [['xml file', xml_file.id]]
      end
    end
  end
end
