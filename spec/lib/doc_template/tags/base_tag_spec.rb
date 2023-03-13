# frozen_string_literal:true

require 'rails_helper'

class BaseSpecTag < DocTemplate::Tags::BaseTag
  TAG_NAME = 'image'
end

describe DocTemplate::Tags::BaseTag do
  describe '.tag_with_html_regexp' do
    let(:content) do
      <<~HTML
        <p style='padding:0;font-size:11pt;font-family:"Arial";line-height:1.5;text-align:left'><span style='
        vertical-align:baseline;font-size:11pt;font-family:"Cabin";'>[image:OP.PT.L13.014, 50, Esta imagen
        muestra ruedas de carretas que han sido enterradas por la tierra movida por el viento durante una
        tormenta de polvo.] Los Estados Unidos tienen una historia trágica con sedimentos en movimiento por el viento
        Durante la década de 1930, gran parte de los Estados Unidos estaba pasando por una sequía.</span></p>
      HTML
    end

    subject { BaseSpecTag.tag_with_html_regexp }

    it 'returns RegExp for a single match only' do
      data = subject.match(content)
      expect(data.size).to eq 1
    end

    context 'when TAG_NAME is not defined' do
      before { BaseSpecTag.send :remove_const, :TAG_NAME }

      it 'raises an error' do
        expect { subject }.to raise_error(NotImplementedError)
      end
    end
  end
end
