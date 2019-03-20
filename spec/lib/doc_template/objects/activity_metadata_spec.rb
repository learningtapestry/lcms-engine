# frozen_string_literal: true

require 'rails_helper'
require 'doc_template/objects/activity_metadata'

describe DocTemplate::Objects::ActivityMetadata do
  describe '.build_from' do
    subject { DocTemplate::Objects::ActivityMetadata.build_from(activity_table) }
    let(:sections) { DocTemplate::Objects::SectionsMetadata.build_from(sections_table, 'core') }

    describe 'empty data' do
      let(:activity_table) { [] }

      it 'returns empty object' do
        expect(subject.children.size).to eq 0
      end
    end

    describe 'correct data' do
      describe 'with single section' do
        let(:activity_table) do
          [{ 'activity-type' => 'Fluency Activity',
             'activity-title' => 'Skip-Count by Tens: Up and Down Crossing 100',
             'activity-source' => 'ENY-G2-M3-L1-F#4', 'activity-materials' => '',
             'activity-standard' => '2.NBT.A.2', 'activity-mathematical-practice' => '',
             'activity-time' => '2 min', 'activity-priority' => '2', 'activity-metacognition' => '',
             'activity-guidance' => '', 'activity-content-development-notes' => '' },
           { 'activity-type' => 'Fluency Activity',
             'activity-title' => 'Unit Form Counting from 398 to 405', 'activity-source' => 'ENY-G2-M3-L6-F#2',
             'activity-materials' => 'ENY-G2-M3-L4-T#1', 'activity-standard' => '2.NBT.A.3',
             'activity-mathematical-practice' => '6', 'activity-time' => '', 'activity-priority' => '1',
             'activity-metacognition' => '', 'activity-guidance' => '', 'activity-content-development-notes' => '' },
           { 'activity-type' => 'Fluency Activity',
             'activity-title' => 'Unit Form Counting from 398 to 405', 'activity-source' => 'ENY-G2-M3-L6-F#2',
             'activity-materials' => 'ENY-G2-M3-L4-T#1', 'activity-standard' => '2.NBT.A.3',
             'activity-mathematical-practice' => '6', 'activity-time' => '3 min', 'activity-priority' => '1',
             'activity-metacognition' => '', 'activity-guidance' => '', 'activity-content-development-notes' => '' }]
        end

        let(:sections_table) do
          [{ 'section-title' => 'Opening', 'section-summary' => 'bla bla bla' }]
        end

        before do
          subject.children.each { |a| sections.children[0].add_activity a }
        end

        it 'returns valid object' do
          expect(subject.children.size).to eq 3
          expect(subject.children[0].title).to eq 'Skip-Count by Tens: Up and Down Crossing 100'
          expect(subject.children[0].time).to eq 2
          expect(subject.children[1].activity_time).to eq 0
          expect(subject.children[2].time).to eq 3

          expect(sections.children[0].children.size).to eq 3
          expect(sections.children[0].time).to eq 5
          expect(sections.children[0].title).to eq 'Opening'
        end
      end

      describe 'with multiple section' do
        let(:activity_table) do
          [{ 'activity-type' => 'Fluency Activity',
             'activity-title' => 'Skip-Count by Tens: Up and Down Crossing 100',
             'activity-source' => 'ENY-G2-M3-L1-F#4', 'activity-materials' => '',
             'activity-standard' => '2.NBT.A.2', 'activity-mathematical-practice' => '',
             'activity-time' => '2 min', 'activity-priority' => '2', 'activity-metacognition' => '',
             'activity-guidance' => '', 'activity-content-development-notes' => '' },
           { 'activity-type' => 'Fluency Activity',
             'activity-title' => 'Unit Form Counting from 398 to 405', 'activity-source' => 'ENY-G2-M3-L6-F#2',
             'activity-materials' => 'ENY-G2-M3-L4-T#1', 'activity-standard' => '2.NBT.A.3',
             'activity-mathematical-practice' => '6', 'activity-time' => '', 'activity-priority' => '1',
             'activity-metacognition' => '', 'activity-guidance' => '', 'activity-content-development-notes' => '' },
           { 'activity-type' => 'Fluency Activity',
             'activity-title' => 'Unit Form Counting from 398 to 405', 'activity-source' => 'ENY-G2-M3-L6-F#2',
             'activity-materials' => 'ENY-G2-M3-L4-T#1', 'activity-standard' => '2.NBT.A.3',
             'activity-mathematical-practice' => '6', 'activity-time' => '3 min', 'activity-priority' => '1',
             'activity-metacognition' => '', 'activity-guidance' => '', 'activity-content-development-notes' => '' }]
        end

        let(:sections_table) do
          [{ 'section-title' => 'Opening', 'section-summary' => 'bla bla bla' },
           { 'section-title' => 'Opening 2', 'section-summary' => 'ble ble ble' }]
        end

        before do
          subject.children[0..1].each { |a| sections.children[0].add_activity a }
          sections.children.last.add_activity subject.children.last
        end

        it 'returns valid object' do
          expect(sections.children.size).to eq 2
          expect(sections.children.first.title).to eq 'Opening'
          expect(sections.children.last.title).to eq 'Opening 2'
          expect(sections.children.first.time).to eq 2
          expect(sections.children.last.time).to eq 3
          expect(sections.children.first.children.size).to eq 2
          expect(sections.children.last.children.size).to eq 1
        end
      end

      describe 'with materials' do
        let(:material_ids) { [1, 2] }
        let(:activity_table) do
          [{ 'section-title' => 'Opening', 'activity-type' => 'Fluency Activity',
             'activity-title' => 'Skip-Count by Tens: Up and Down Crossing 100',
             'activity-source' => 'ENY-G2-M3-L1-F#4', 'material_ids' => material_ids,
             'activity-materials' => '', 'activity-standard' => '2.NBT.A.2',
             'activity-mathematical-practice' => '', 'activity-time' => '2 min',
             'activity-priority' => '2', 'activity-metacognition' => '',
             'activity-guidance' => '', 'activity-content-development-notes' => '' }]
        end

        it 'returns material ids' do
          expect(subject.children[0].material_ids).to eq material_ids
        end
      end
    end
  end
end
