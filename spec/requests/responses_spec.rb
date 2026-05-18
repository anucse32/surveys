require "rails_helper"

RSpec.describe "Responses", type: :request do
  let(:survey) { create(:survey) }

  describe "POST /surveys/:survey_id/responses" do
    it "creates a yes response when answer=yes" do
      expect {
        post survey_responses_path(survey, answer: "yes")
      }.to change(survey.responses, :count).by(1)
      expect(survey.responses.reload.last.answer).to eq(true)
      expect(response).to redirect_to(surveys_path)
    end

    it "creates a no response when answer=no" do
      expect {
        post survey_responses_path(survey, answer: "no")
      }.to change(survey.responses, :count).by(1)
      expect(survey.responses.reload.last.answer).to eq(false)
      expect(response).to redirect_to(surveys_path)
    end

    it "allows the same survey to be answered multiple times" do
      expect {
        post survey_responses_path(survey, answer: "yes")
        post survey_responses_path(survey, answer: "no")
        post survey_responses_path(survey, answer: "yes")
      }.to change(survey.responses, :count).by(3)
    end

    it "redirects back to the survey when no answer is provided" do
      expect {
        post survey_responses_path(survey)
      }.not_to change(Response, :count)
      expect(response).to redirect_to(survey_path(survey))
    end
  end
end