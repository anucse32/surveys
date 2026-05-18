require "rails_helper"

RSpec.describe "Surveys", type: :request do
  describe "GET /surveys" do
    it "renders the index" do
      create(:survey, question: "Is Ruby fun?")
      get surveys_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Is Ruby fun?")
    end
  end

  describe "GET /surveys/new" do
    it "renders the new form" do
      get new_survey_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Create a new survey")
    end
  end

  describe "POST /surveys" do
    context "with valid params" do
      it "creates a survey and redirects to the index" do
        expect {
          post surveys_path, params: { survey: { question: "Do you like tea?" } }
        }.to change(Survey, :count).by(1)
        expect(response).to redirect_to(surveys_path)
      end
    end

    context "with invalid params" do
      it "does not create a survey and re-renders the form" do
        expect {
          post surveys_path, params: { survey: { question: "" } }
        }.not_to change(Survey, :count)
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "GET /surveys/:id" do
    it "renders the show page" do
      survey = create(:survey, question: "Tabs or spaces?")
      get survey_path(survey)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Tabs or spaces?")
    end
  end
end