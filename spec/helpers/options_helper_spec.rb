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
        file_set = FileSet.new do |gf|
          gf.apply_depositor_metadata('jcoyne')
          gf.mime_type = 'application/xml'
          gf.label = 'xml file'
        end
        file_path = File.join(fixture_path, 'tei', xml_file_name)
        Hydra::Works::AddFileToFileSet.call(file_set, File.open(file_path), :original_file)
        file_set
      end

      let(:pdf_file) do
        file_set = FileSet.new do |gf|
          gf.apply_depositor_metadata('jcoyne')
          gf.mime_type = 'application/pdf'
          gf.label = 'pdf file'
        end
        file_path = File.join(fixture_path, pdf_file_name)
        Hydra::Works::AddFileToFileSet.call(file_set, File.open(file_path), :original_file)
        file_set
      end

      it 'only returns XML files as options' do
        # Make sure the test is set up properly, with one XML
        # and one PDF file.
        expect(obj.file_sets.map(&:mime_type)).to eq ['application/xml', 'application/pdf']
        expect(subject).to eq [['xml file', xml_file.id]]
      end
    end
  end
end
