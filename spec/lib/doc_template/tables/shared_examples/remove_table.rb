# frozen_string_literal: true

require 'rails_helper'

shared_examples 'removes metadata table' do
  it 'removes original table' do
    table_html = %r{<span\s+[^.]*>\[?#{described_class::HEADER_LABEL}\]?</span>}im
    subject
    expect(fragment.to_html).to_not match(table_html)
  end
end
