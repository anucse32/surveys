require 'rails_helper'

RSpec.describe Survey, type: :model do
  describe "validations" do
    it "is valid with a question" do
      expect(build(:survey, question: "Do you like Ruby?")).to be_valid
    end

    it "is invalid without a question" do
      survey = build(:survey, question: nil)
      expect(survey).not_to be_valid
      expect(survey.errors[:question]).to include("can't be blank")
    end

    it "is invalid with a question longer than 500 characters" do
      expect(build(:survey, question: "a" * 501)).not_to be_valid
    end
  end

  describe "associations" do
    it "destroys dependent responses when destroyed" do
      survey = create(:survey)
      create(:response, survey: survey)
      expect { survey.destroy }.to change(Response, :count).by(-1)
    end
  end

  describe "result calculations" do
    let(:survey) { create(:survey) }

    context "with no responses" do
      it "returns 0 for yes_percentage and no_percentage" do
        expect(survey.yes_percentage).to eq(0)
        expect(survey.no_percentage).to eq(0)
      end

      it "returns 0 responses_count" do
        expect(survey.responses_count).to eq(0)
      end
    end

    context "with mixed responses" do
      before do
        create_list(:response, 3, survey: survey, answer: true)
        create(:response, survey: survey, answer: false)
      end

      it "calculates yes_percentage" do
        expect(survey.yes_percentage).to eq(75)
      end

      it "calculates no_percentage" do
        expect(survey.no_percentage).to eq(25)
      end

      it "counts responses" do
        expect(survey.responses_count).to eq(4)
      end
    end
  end

  describe ".with_response_stats" do
    it "loads counts in a single query without N+1" do
      s1 = create(:survey)
      s2 = create(:survey)
      create(:response, survey: s1, answer: true)
      create(:response, survey: s1, answer: false)
      create(:response, survey: s2, answer: true)

      result = Survey.with_response_stats.order(:id).to_a
      first, second = result

      expect(first.responses_count).to eq(2)
      expect(first.yes_count).to eq(1)
      expect(first.yes_percentage).to eq(50)

      expect(second.responses_count).to eq(1)
      expect(second.yes_count).to eq(1)
      expect(second.yes_percentage).to eq(100)
    end
  end
end
