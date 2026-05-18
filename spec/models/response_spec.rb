require 'rails_helper'

RSpec.describe Response, type: :model do
  describe "validations" do
    it "is valid with answer true" do
      expect(build(:response, answer: true)).to be_valid
    end

    it "is valid with answer false" do
      expect(build(:response, answer: false)).to be_valid
    end

    it "is invalid without an answer" do
      response = build(:response, answer: nil)
      expect(response).not_to be_valid
      expect(response.errors[:answer]).to be_present
    end

    it "is invalid without a survey" do
      expect(build(:response, survey: nil)).not_to be_valid
    end
  end

  describe "timestamps" do
    it "records when the response was saved" do
      response = create(:response)
      expect(response.created_at).to be_present
    end
  end
end
