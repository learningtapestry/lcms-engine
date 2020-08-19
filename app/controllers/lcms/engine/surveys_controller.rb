# frozen_string_literal: true

module Lcms
  module Engine
    class SurveysController < Lcms::Engine::ApplicationController
      skip_before_action :check_user_has_survey_filled_in

      def create
        @form = SurveyForm.new(permitted_params)
        if @form.valid?
          current_user.update(survey: @form.attributes)
          loc = stored_location_for(:user)
          loc = lcms_engine.root_path if loc.is_a?(String) && loc[survey_path]
          redirect_to loc || lcms_engine.root_path
        else
          render :show
        end
      end

      def show
        return redirect_to lcms_engine.root_path if current_user.ready_to_go?

        @form = SurveyForm.new(current_user.survey)
      end

      private

      def permitted_params
        params.require(:survey_form).permit(
          :additional_period,
          :additional_period_minutes,
          :district_or_system,
          :district_or_system_other,
          :first_name,
          :last_name,
          :number_of_minutes,
          :prior_experience,
          :subject_or_grade,
          :subject_or_grade_other
        )
      end
    end
  end
end
