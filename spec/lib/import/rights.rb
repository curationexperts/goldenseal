require 'rails_helper'
require 'import'

describe Import::Rights do
  let(:pub_dom_url) { 'http://creativecommons.org/publicdomain/mark/1.0/' }
  let(:rr_url) { 'http://www.europeana.eu/portal/rights/rr-r.html' }

  describe 'url_for' do
    context 'exact match for public domain work' do
      let(:pub_dom_strings) { ['publicDomain', 'pubLic  domain', 'Public domAin'] }

      it 'sets the URL for public domain works' do
        pub_dom_strings.each do |rights_string|
          expect(described_class.url_for(rights_string)).to eq pub_dom_url
        end
      end
    end

    context 'regex match for public domain work' do
      let(:rights_string) { 'work is in the public domain.' }

      it 'sets the URL for public domain works' do
        expect(described_class.url_for(rights_string)).to eq pub_dom_url
      end
    end

    context "when it doesn't match any known rights statement" do
      let(:rights_string) { 'some other rights statement' }

      it 'sets the default URL for "All Rights Reserved"' do
        expect(described_class.url_for(rights_string)).to eq rr_url
      end
    end

    context "when string is blank" do
      it 'sets the default URL for "All Rights Reserved"' do
        expect(described_class.url_for('')).to eq rr_url
        expect(described_class.url_for(nil)).to eq rr_url
      end
    end
  end

end
