# frozen_string_literal: true

require 'google/apis/drive_v3'

class LessonsGdocBundler
  PDF_LINKS_KEYS = { full: 'gdoc_full', tm: 'gdoc_tm', sm: 'gdoc_sm' }.freeze

  def initialize(unit)
    @unit = unit
  end

  def bundle
    return if unit.children.empty?

    # ensure root folder exists
    root_id = drive_service.create_folder root_folder

    unit_folder = drive_service.create_folder dirname(unit), root_id

    unit.children.includes(:documents).each do |resource|
      next unless resource.document?

      build_lesson_folder resource, unit_folder
    end

    # return (and save somewhere the unit bundle url)
    "https://drive.google.com/open?id=#{unit_folder}"
  rescue Google::Apis::TransmissionError => e
    Rails.logger.error "Failed to bundle unit: #{unit.slug}, #{e.message}"
  end

  private

  attr_reader :unit

  def build_lesson_folder(resource, unit_folder)
    document = resource.document
    # create lesson bundle folder
    lesson_bundle = drive_service.create_folder dirname(resource), unit_folder

    # copy files from gdoc_full
    full_folder = drive_id document.links[PDF_LINKS_KEYS[:full]]
    return unless full_folder

    drive_service.copy_files full_folder, lesson_bundle

    # materials
    %i(tm sm).each do |mtype|
      build_materials_folder document, lesson_bundle, mtype
    end
  rescue Google::Apis::ServerError => e
    Rails.logger.error "Failed to build lesson folder for #{resource.id}, #{e.message}"
  end

  def build_materials_folder(document, lesson_bundle, type)
    folder = drive_id document.links[PDF_LINKS_KEYS[type]]
    return unless folder

    name = type == :sm ? 'Student Materials' : 'Teacher Materials'
    materials_bundle = drive_service.create_folder name, lesson_bundle
    drive_service.copy_files folder, materials_bundle
  rescue Google::Apis::ServerError => e
    Rails.logger.error "Failed to build materials folder: #{document&.resource&.id} #{type}, #{e.message}"
  end

  def dirname(res)
    subject = res.subject.casecmp('math').zero? ? 'Math' : 'ELA'
    Breadcrumbs.new(res).short_pieces[1..-1].unshift(subject).join('-')
  end

  def drive_id(url)
    return unless url

    url.match(%r{drive\.google\.com/open\?id=([^/]+)})&.[](1)
  end

  def drive_service
    @drive_service ||= Google::DriveService.build(nil, gdoc_folder: root_folder)
  end

  def root_folder
    @root_folder ||= ENV['BUNDLES_ROOT_FOLDER'].presence || "unit-bundles-#{Rails.env}"
  end
end
