# frozen_string_literal: true

class SurveysController < ApplicationController
  skip_before_action :check_user_has_survey_filled_in

  def create
    @form = SurveyForm.new(permitted_params)
    if @form.valid?
      current_user.update(survey: @form.attributes)
      notify_heap
      loc = stored_location_for(:user)
      loc = root_path if loc.is_a?(String) && loc[survey_path]
      redirect_to loc || root_path
    else
      render :show
    end
  end

  def show
    return redirect_to root_path if current_user.ready_to_go?

    @form = SurveyForm.new(current_user.survey)
  end

  private

  def notify_heap
    data = current_user
             .survey.except('first_name', 'last_name')
             .merge(
               access_code: current_user.access_code,
               email: current_user.email
             )
    Heap.add_user_properties current_user.id, data
  end

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
