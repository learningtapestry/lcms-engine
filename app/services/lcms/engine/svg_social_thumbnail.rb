# frozen_string_literal: true

module Lcms
  module Engine
    class SVGSocialThumbnail
      include ERB::Util

      SIZE_MAP = {
        all: { width: 600, height: 600 },
        facebook: { width: 1200, height: 627 },
        pinterest: { width: 600, height: 800 },
        twitter: { width: 440, height: 220 }
      }.with_indifferent_access

      COLOR_CODES = {
        ela_base: '#f75b28',
        ela_pk: '#fda43a',
        ela_k: '#fc9837',
        ela_1: '#fb8d32',
        ela_2: '#f7802c',
        ela_3: '#f97529',
        ela_4: '#f96924',
        ela_5: '#f85e20',
        ela_6: '#f0501a',
        ela_7: '#e94d1a',
        ela_8: '#e14b19',
        ela_9: '#da4818',
        ela_10: '#d34617',
        ela_11: '#cc4417',
        ela_12: '#c54116',

        math_base: '#00a699',
        math_pk: '#69d59d',
        math_k: '#5bcf9d',
        math_1: '#4cc89c',
        math_2: '#3cc19b',
        math_3: '#2ebb9b',
        math_4: '#1eb49a',
        math_5: '#0fad9a',
        math_6: '#009d90',
        math_7: '#009488',
        math_8: '#008b7f',
        math_9: '#008277',
        math_10: '#00796e',
        math_11: '#007066',
        math_12: '#00675d'
      }.freeze

      attr_reader :resource, :media

      def initialize(model, media: nil)
        @resource = model
        @media = media || :all
      end

      def render
        @render ||= ERB.new(template).result(binding)
      end

      def self.template
        @template ||= File.read Rails.root.join('app', 'views', 'shared', 'social_thumbnail.svg.erb')
      end

      def template
        self.class.template
      end

      # =========================
      # Helper methods

      def asset_path(asset)
        ApplicationController.helpers.asset_path(asset)
      end

      def self.base64_cache
        @base64_cache ||= {}
      end

      def base64_cache
        self.class.base64_cache
      end

      def base64_encoded_asset(asset)
        base64_cache.fetch asset do
          encoded = ApplicationController.helpers.base64_encoded_asset(asset)
          if asset.match?(/\.ttf$/)
            encoded.gsub!('data:application/x-font-ttf;base64,', 'data:font/truetype;charset=utf-8;base64,')
          end
          base64_cache[asset] = encoded
        end
      end

      def size
        SIZE_MAP[media]
      end

      def logo_size
        proportion = footer_size / 100.0
        { width: 220 * proportion, height: 30 * proportion }
      end

      def footer_size
        case media
        when :twitter
          50
        else
          100
        end
      end

      def em
        case media
        when :twitter
          12
        when :facebook
          26
        else
          22
        end
      end

      def style
        @style ||= {
          padding: 2 * em,
          font_size: em,
          font_size_big: (
            case media
            when :facebook
              3 * em
            when :pinterest
              3.25 * em
            else
              2.5 * em
            end
          )
        }.with_indifferent_access
      end

      def title_width_threshold
        case media
        when :twitter
          31
        when :facebook
          32
        when :pinterest
          16
        else
          21
        end
      end

      def number_of_lines
        case media
        when :facebook
          4
        when :pinterest
          (header_with_two_lines? ? 6 : 7)
        when :twitter
          3
        else
          6
        end
      end

      def title_top_margin
        header_with_two_lines? ? 3 * style[:padding] : 2 * style[:padding]
      end

      def subject_and_grade
        grades = resource.grades.to_str
        subject = resource.subject == 'ela' ? 'ELA' : 'Math'
        case grades
        when 'Grade PK'
          "#{subject}  Prekindergarten"
        when 'Grade K'
          "#{subject}  Kindergarten"
        else
          "#{subject}  #{grades}"
        end
      end

      def resource_type
        resource.class.name.underscore
      end

      def content_type
        if resource.generic? || resource.media?
          I18n.t("resource_types.#{resource.resource_type}").upcase
        elsif resurce.unit? && resource.short_title.match(/topic/i)
          'TOPIC'
        elsif resource.lesson?
          'LESSON PLAN'
        else
          resource.curriculum_type.try(:upcase)
        end
      end

      def header_with_two_lines?
        media == :pinterest && resource.try(:quick_reference_guide?)
      end

      def title_sentences
        buffer = ''
        sentences = []
        resource.title.gsub(/(\w)-(\w)/, '\1- \2').split.each do |word|
          if (buffer + word).size < title_width_threshold
            buffer = [buffer, word].select(&:present?).join(' ')
            buffer = buffer.gsub(/(\w)- (\w)/, '\1-\2')
          else
            sentences << buffer
            buffer = word
          end
        end
        sentences << buffer unless buffer.empty?
      end

      def color_code
        grade = resource.grades.average rescue :base
        COLOR_CODES[:"#{resource.subject}_#{grade}"]
      end
    end
  end
end
