require "rails_helper"

RSpec.describe "Survey flow", type: :system do
  it "lets a user create a survey, respond, and see results" do
    visit root_path
    expect(page).to have_content("No surveys yet")

    within("header") { click_link "New survey" }
    fill_in "Question", with: "Do you like Ruby?"
    click_button "Create survey"

    expect(page).to have_content("Survey created.")
    expect(page).to have_content("Do you like Ruby?")
    expect(page).to have_content("No responses yet.")

    click_link "Respond"
    click_button "Yes"

    expect(page).to have_content("Response recorded.")

    click_link "Respond"
    click_button "No"

    within("article", text: "Do you like Ruby?") do
      expect(page).to have_content("50% (1)", count: 2)
      expect(page).to have_content("2 responses")
    end
  end
end