require 'rails_helper'

RSpec.describe "Projects", type: :system do
  include LoginSupport

  scenario 'user creates a new project' do
    user = FactoryBot.create(:user)
    sign_in_as(user)

    expect {
      click_link 'New Project'
      fill_in 'Name', with: 'Test project'
      fill_in 'Description', with: 'This is a test project.'
      click_button 'Create Project'

      aggregate_failures do # 1つ目のexpectが失敗しても継続してテストを行える。
        expect(page).to have_content 'Project was successfully created.'
        expect(page).to have_content 'Test project'
        expect(page).to have_content "Owner: #{user.name}"
      end
    }.to change(user.projects, :count).by(1)
  end
end
