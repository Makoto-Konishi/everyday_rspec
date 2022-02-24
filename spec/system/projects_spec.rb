require 'rails_helper'

RSpec.describe "Projects", type: :system do
  before do
    driven_by(:rack_test)
  end

  scenario 'user creates a new project' do
    user = FactoryBot.create(:user)

    visit root_path # root_pathに移動する
    click_link 'Sign in' # Sign inボタンを押す
    fill_in 'Email', with: user.email # emailを入力する
    fill_in 'Password', with: user.password # passwordを入力する
    click_button 'Log in' # Log inボタンを押す

    expect {
      click_link 'New Project'
      fill_in 'Name', with: 'Test project'
      fill_in 'Description', with: 'This is a test project.'
      click_button 'Create Project'

      expect(page).to have_content 'Project was successfully created.'
      expect(page).to have_content 'Test project'
      expect(page).to have_content "Owner: #{user.name}"
    }.to change(user.projects, :count).by(1)
  end
end
