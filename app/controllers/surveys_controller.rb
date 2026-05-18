class SurveysController < ApplicationController
  def index
      @surveys = Survey.with_response_stats.order(created_at: :desc)
  end
  
  def new
    @survey = Survey.new
  end
  
  def create
    @survey = Survey.new(survey_params)
    if @survey.save
      redirect_to surveys_path, notice: "Survey created."
    else
      render :new, status: :unprocessable_content
    end
  end
  
  def show
    @survey = Survey.find(params[:id])
  end
  
  private
  
  def survey_params
    params.require(:survey).permit(:question)
  end
end