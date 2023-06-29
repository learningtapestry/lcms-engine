# frozen_string_literal: true

module Lcms
  module Engine
    module Admin
      class ResourcesController < AdminController
        include Lcms::Engine::ViewHelper

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
            redirect_to lcms_engine.admin_resources_path, notice: t('.success', resource_id: @resource.id)
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
          send_data data, filename:, type: 'application/zip', disposition: 'attachment'
        end

        def bundle
          return redirect_to lcms_engine.admin_resources_path, notice: t('.fail') unless can_bundle?(@resource)

          # see settings loaded via `lcms.yml`
          generator = DocTemplate.config.dig('bundles', @resource.curriculum_type).constantize
          generator.perform(@resource)
          redirect_to lcms_engine.admin_resources_path, notice: t('.success')
        end

        def update
          unless Settings[:editing_enabled]
            return redirect_to(lcms_engine.admin_resources_path, alert: t('lcms.engine.admin.common.editing_disabled'))
          end

          create_tags
          Array.wrap(create_params[:new_standard_names]).each do |std_name|
            std = Standard.create_with(subject: @resource.subject).find_or_create_by!(name: std_name)
            resource_params[:standard_ids] << std.id
          end

          if @resource.update(resource_params)
            redirect_to lcms_engine.admin_resources_path, notice: t('.success', resource_id: @resource.id)
          else
            render :edit
          end
        end

        def destroy
          @resource.destroy
          redirect_to lcms_engine.admin_resources_path, notice: t('.success', resource_id: @resource.id)
        end

        protected

        def form_params_arrays
          {
            additional_resource_ids: [],
            common_core_standard_ids: [],
            related_resource_ids: [],
            standard_ids: [],
            new_standard_names: [],
            topic_ids: [],
            tag_ids: [],
            content_source_ids: [],
            reading_assignment_text_ids: [],
            new_topic_names: [],
            new_tag_names: [],
            new_content_source_names: [],
            **form_params_arrays_override
          }
        end

        #
        # The result of this method will be splatted into +form_params_arrays+
        # and will be injected into the final +form_params+ call.
        #
        # Should be used to extend the list of permitted parameters
        #
        # @return [Hash]
        def form_params_arrays_override
          {}
        end

        def form_params_simple
          %i(
            curriculum_type
            directory
            parent_id
            tree
            description
            hidden
            resource_type
            short_title
            subtitle
            title
            teaser
            url
            time_to_teach
            ell_appropriate
            image_file
            opr_description
          ).concat(form_params_simple_override)
        end

        #
        # The result of this method will be added to +form_params_simple+
        # and will be injected into the final +form_params+ call.
        #
        # Should be used to extend the list of permitted parameters
        #
        # @return [Array]
        def form_params_simple_override
          []
        end

        private

        #
        # @param [Lcms::Engine::Resource] resource
        # @return [Boolean]
        #
        def can_bundle?(resource)
          DocTemplate
            .config['bundles'].keys
            .detect { |type| resource.send "#{type}?" }
            .present?
        end

        helper_method :can_bundle?

        def find_resource
          @resource = Resource.find(params[:id])
        end

        def grade_params
          params.fetch(:q, {}).fetch(:grades, []).select(&:present?)
        end

        def form_params
          @form_params ||=
            begin
              ps = params.require(:resource).permit(
                form_params_simple,
                form_params_arrays
              ).to_h
              directory = ps.delete(:directory)
              ps[:metadata] = metadata directory.split(',') if directory.present?
              ps
            end
        end

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
