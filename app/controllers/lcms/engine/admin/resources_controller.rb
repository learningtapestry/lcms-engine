# frozen_string_literal: true

module Lcms
  module Engine
    module Admin
      class ResourcesController < AdminController
        CREATE_TAG_KEYS = %i(new_topic_names new_tag_names new_content_source_names
                             new_standard_names).freeze
        CREATE_TAG_METHODS = {
          new_topic_names: 'topic',
          new_tag_names: 'tag',
          new_content_source_names: 'content_source'
        }.freeze

        before_action :find_resource, except: %i(index new create)

        def index
          @query = Resource.ransack(params[:q].try(:except, :grades))
          resources = @query.result.includes(:standards)
          resources = resources.where_grade(grade_params) if grade_params.present?
          @resources = resources.order(id: :desc).paginate(page: params[:page], per_page: 15)
        end

        def new
          @resource = Resource.new
        end

        def create
          @resource = Resource.new(resource_params)

          if @resource.save
            create_tags
            redirect_to :admin_resources, notice: t('.success', resource_id: @resource.id)
          else
            render :new
          end
        end

        def edit; end

        def export_to_lti_cc
          # TODO: Later may need to extend this check to allow unit export as well
          unless @resource.module?
            return redirect_back fallback_location: admin_resources_path, notice: 'Unsupported resource type'
          end

          data = LtiExporter.perform @resource
          filename = "#{@resource.slug.parameterize}.zip"
          send_data data, filename: filename, type: 'application/zip', disposition: 'attachment'
        end

        def bundle
          return redirect_to :admin_resources, notice: t('.fail') unless can_bundle?(@resource)

          # see settings loaded via `lcms.yml`
          generator = DocTemplate.config.dig('bundles', @resource.curriculum_type).constantize
          generator.perform(@resource)
          redirect_to :admin_resources, notice: t('.success')
        end

        def update
          unless Settings[:editing_enabled]
            return redirect_to(:admin_resources, alert: t('admin.common.editing_disabled'))
          end

          create_tags
          Array.wrap(create_params[:new_standard_names]).each do |std_name|
            std = Standard.create_with(subject: @resource.subject).find_or_create_by!(name: std_name)
            resource_params[:standard_ids] << std.id
          end

          if @resource.update_attributes(resource_params)
            redirect_to :admin_resources, notice: t('.success', resource_id: @resource.id)
          else
            render :edit
          end
        end

        def destroy
          @resource.destroy
          redirect_to :admin_resources, notice: t('.success', resource_id: @resource.id)
        end

        private

        def can_bundle?(resource)
          DocTemplate
            .config['bundles'].keys
            .detect { |type| resource.send "#{type}?" }
            .present?
        end
        helper_method :can_bundle?

        def find_resource
          @resource = Resource.includes(resource_downloads: :download).find(params[:id])
        end

        def grade_params
          params.fetch(:q, {}).fetch(:grades, []).select(&:present?)
        end

        # rubocop:disable Metrics/MethodLength
        def form_params
          @form_params ||=
            begin
              download_categories_settings =
                DownloadCategory.select(:title).map do |category|
                  { category.title.parameterize => %i(show_long_description show_short_description) }
                end
              ps = params.require(:resource).permit(
                :curriculum_type,
                :directory,
                :parent_id,
                :tree,
                :description,
                :hidden,
                :resource_type,
                :short_title,
                :subtitle,
                :title,
                :teaser,
                :url,
                :time_to_teach,
                :ell_appropriate,
                :image_file,
                :opr_description,
                additional_resource_ids: [],
                common_core_standard_ids: [],
                download_categories_settings: download_categories_settings,
                resource_downloads_attributes: [
                  :_destroy,
                  :description,
                  :id,
                  :download_category_id, { download_attributes: %i(description file main filename_cache id title) }
                ],
                related_resource_ids: [],
                standard_ids: [],
                new_standard_names: [],
                topic_ids: [],
                tag_ids: [],
                content_source_ids: [],
                reading_assignment_text_ids: [],
                new_topic_names: [],
                new_tag_names: [],
                new_content_source_names: []
              ).to_h
              if ps[:download_categories_settings].present?
                ps[:download_categories_settings].transform_values! do |settings|
                  settings.transform_values! { |x| x == '1' }
                end
              end
              ps[:metadata] = metadata ps.delete(:directory)&.split(',')
              ps
            end
        end
        # rubocop:enable Metrics/MethodLength

        def metadata(directory)
          return {} unless @resource.present?

          @resource.metadata.merge Resource.metadata_from_dir(directory)
        end

        def resource_params
          @resource_params ||= form_params.except(*CREATE_TAG_KEYS)
        end

        def create_params
          @create_params ||= form_params.slice(*CREATE_TAG_KEYS)
        end

        def create_tags
          CREATE_TAG_METHODS.each do |params_key, basename|
            Array.wrap(create_params[params_key]).each do |name|
              @resource.send("#{basename}_list").push(name) if name.present?
            end
          end
        end
      end
    end
  end
end
