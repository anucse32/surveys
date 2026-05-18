class ResponsesController < ApplicationController
  ANSWER_MAPPING = { "yes" => true, "no" => false }.freeze

  def create
    survey = Survey.find(params[:survey_id])
    answer = ANSWER_MAPPING[params[:answer].to_s.downcase]

    if answer.nil?
      redirect_to survey_path(survey), alert: "Please choose Yes or No."
      return
    end

    survey.responses.create!(answer: answer)
    redirect_to surveys_path, notice: "Response recorded."
  end
end
