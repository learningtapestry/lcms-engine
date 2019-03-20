# frozen_string_literal: true

require 'rails_helper'

describe DocTemplate::Template do
  let(:html_document) do
    <<-HTML
      <html>
        <head></head>
        <body>
          <table><tr><td>#{DocTemplate::Tables::Metadata::HEADER_LABEL}</td></tr></table>
          #{content}
        </body>
      </html>
    HTML
  end

  describe 'tag rendering' do
    let(:tag) { '<span>[ATAG: </span><span>ending]</span>' }

    describe 'capturing tags on multiple nodes' do
      let(:content) { "<p><span>stay</span>#{tag}</p><p>info to slice</p>" }

      subject { DocTemplate::Template.parse(html_document).render }

      context 'when default tag should be removed' do
        before { DocTemplate::Tags.config['default']['remove'] = true }

        it { is_expected.to_not include(tag) }
      end

      context 'when default tag should be keeped' do
        before { DocTemplate::Tags.config['default']['remove'] = false }

        it { is_expected.to include(tag) }

        it { is_expected.to include('data-parsed="true"') }
      end
    end

    describe 'default tag' do
      let(:tag) { '<p><span>[ATAG some info]</span></p>' }
      let(:content) { "#{tag}<p>info to slice</p>" }

      subject { DocTemplate::Template.parse(html_document) }

      it 'renders the default' do
        expect(subject.render).to include content.sub(tag, '')
      end
    end

    # TODO: refactor to the actual state
    xdescribe 'tokenization' do
      let(:tag) { '<p><span>[ATAG some info]</span>[ANOTHERTAG blbl]</p>' }
      let(:content) { "#{tag}<p>info to slice</p>" }
      subject { DocTemplate::Template.parse(html_document) }

      it 'replaces the tag node with a placeholder' do
        expect(subject.render).to match(/{{default_tag_\w+}}/)
      end

      it 'replaces nested tags with placeholders' do
        skip
        expect(subject.render).to match(/(.?default_tag_\w+){2}/)
      end
    end

    # TODO: refactor to the actual state
    xdescribe '#parts' do
      let(:tag) { '<p><span>[ATAG some info]</span>[ANOTHERTAG blbl]</p>' }
      let(:content) { "#{tag}<p>info to slice</p>" }
      subject { DocTemplate::Template.parse(html_document) }

      it 'returns the placeholder and the tag content' do
        expect(subject.parts.first[:placeholder]).to include 'default_tag_'
        expect(subject.parts.first[:content]).to eq tag
        expect(subject.parts.first[:part_type]).to eq 'ATAG'
      end
    end
  end
end
