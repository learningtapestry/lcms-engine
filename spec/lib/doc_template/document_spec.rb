# frozen_string_literal: true

require 'rails_helper'

describe DocTemplate::Document do
  describe '.parse' do
    let(:nodes) { Nokogiri::HTML.fragment("<p><span>#{tag}</span></p>") }
    let(:options) { { context_type: 'default' } }

    subject { described_class.parse(nodes, options) }

    context 'with a tag registered with Regexp' do
      ['[page-break]', '[pagebreak]', '[Page-Break]', '[page break]', '[Page Break]', '[PAGE  BREAK]'].each do |t|
        context "when tag is #{t}" do
          let(:tag) { t }

          it 'substitutes the tag' do
            expect(subject.parts.size).to eq 1
            expect(subject.parts.first[:content]).to include DocTemplate::Tags::PageBreakTag::CSS_CLASS
            expect(subject.render).to include subject.parts.first[:placeholder]
            expect(subject.render).to_not include t
          end
        end
      end
    end

    context 'when the name of the tag registered with Regexp belongs to another tag' do
      let(:tag_class) do
        Class.new(DocTemplate::Tags::PageBreakTag) do
          const_set :TAG_NAME, /section(-|\s*)break/
        end
      end

      before { DocTemplate::Template.register_tag(tag_class::TAG_NAME, tag_class) }
      after { DocTemplate::Template.unregister_tag(tag_class::TAG_NAME) }

      ['[section-break]', '[sectionbreak]', '[section break]', '[Section Break]', '[SECTION  BREAK]'].each do |t|
        context "when tag is #{t}" do
          let(:tag) { t }

          it 'substitutes the tag' do
            expect(subject.parts.size).to eq 1
            expect(subject.parts.first[:content]).to include DocTemplate::Tags::PageBreakTag::CSS_CLASS
            expect(subject.render).to_not include t
          end
        end
      end

      context 'when tag is written with a colon' do
        let(:tag) { '[section: break]' }

        before { allow(DocTemplate::Tags::SectionTag).to receive(:parse).and_raise('section tag') }

        it 'is handled by another tag' do
          expect { subject }.to raise_error('section tag')
        end
      end
    end

    context 'when only a part of the tag matches the Regexp' do
      ['[page breaker]', '[front page break]', '[unknown page break]', '[page: break]'].each do |t|
        context "when tag is #{t}" do
          let(:tag) { t }

          it 'does not treat it as the tag' do
            expect(subject.parts).to be_empty
          end
        end
      end
    end
  end
end
