# frozen_string_literal: true

require 'rails_helper'
require 'doc_template/objects/agenda_metadata'

describe DocTemplate::Objects::AgendaMetadata do
  describe '.build_from' do
    subject { DocTemplate::Objects::AgendaMetadata.build_from(agenda_table) }

    describe 'empty data' do
      let(:agenda_table)  { [] }

      it 'returns empty object' do
        expect(subject.children.size).to eq 0
      end
    end

    describe 'correct data' do
      describe 'calculates time hierarchily' do
        let(:agenda_table) do
          [
            {
              id: 'work-time-a',
              title: 'Work Time A',
              metadata: {
                'metadata' => '',
                'standard' => '?',
                'group_size' => '?',
                'ccss_strand' => '?',
                'ccss_sub_strand' => '?'
              },
              metacognition: { content: "\n\n\n\n" },
              children: [
                {
                  id: 'a-establishing-a-context',
                  title: 'A Establishing a Context',
                  metadata: {
                    'metadata' => '',
                    'standard' => '?',
                    'group_size' => '?',
                    'ccss_strand' => '?',
                    'ccss_sub_strand' => '?',
                    'time' => '10'
                  },
                  metacognition: { content: content_1 },
                  children: []
                },
                {
                  id: 'b-skill-builder-preteach-vocabulary',
                  title: 'B Skill Builder: Preteach Vocabulary',
                  metadata: {
                    'metadata' => '',
                    'standard' => '?',
                    'group_size' => '?',
                    'ccss_strand' => '?',
                    'ccss_sub_strand' => '?',
                    'time' => '10'
                  },
                  metacognition: { content: content_2 },
                  children: []
                },
                {
                  id: 'c-whole-class-read-of-chapter-1-who-is-bud',
                  title: 'C Whole Class Read of Chapter 1: Who Is Bud',
                  metadata: {
                    'metadata' => '',
                    'standard' => '?',
                    'group_size' => '?',
                    'ccss_strand' => '?',
                    'ccss_sub_strand' => '?',
                    'time' => '20'
                  },
                  metacognition: { content: content_3 },
                  children: []
                },
                {
                  id: 'empty-time',
                  title: 'Empty Time',
                  metadata: {
                    'time' => '',
                    'standard' => '?'
                  }
                }
              ]
            }
          ]
        end
        let(:content_1) do
          <<-HTML
            \n\nProvide an experience that allows students to establish a context for the text through engaging with
            the standards.   Analyze an image to practice the skills of a close reader, such as asking questions,
            noticing details, and looking back multiple times for different purposes. [QRD: Using Art with Text]\n
          HTML
        end
        let(:content_2) do
          <<-HTML
            \n\n\nPreteach vocabulary words that are critical to understanding the passage but difficult to discern
            using context clues. [QRD: Vocabulary]\n\n\n\n
          HTML
        end
        let(:content_3) do
          <<-HTML
            \n\n\nWhen using grade level text at the beginning of the year, read aloud portions of text as students
            follow along to the students to model fluency and provide opportunity for basic comprehension before
            directing students to engage with it for close reading. [QRD: Fluency]\n\n
          HTML
        end

        it 'returns valid object' do
          expect(subject.children.size).to eq 1
          expect(subject.children[0].title).to eq 'Work Time A'
          expect(subject.children[0].metadata.time).to eq 40
          expect(subject.children[0].children.size).to eq 4
          expect(subject.children[0].children[1].metadata.time).to eq 10
          expect(subject.children[0].children[3].metadata.time).to eq 0
        end
      end
    end
  end
end
