require 'rails_helper'

RSpec.describe "Tasks", type: :system do

  scenario 'user toggles a task', js: true do
    user = FactoryBot.create(:user)
    project = FactoryBot.create(:project, name: 'Test Project', owner: user)
    task = project.tasks.create!(name: 'A Test Task Of Test Project')

    visit root_path
    click_link 'Sign in'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'

    click_link 'Test Project'
    check 'A Test Task Of Test Project'
    expect(page).to have_css "label#task_#{task.id}.completed"
    expect(task.reload).to be_completed

    uncheck 'A Test Task Of Test Project'
    expect(page).to_not have_css "label#task_#{task.id}.completed"
    expect(task.reload).to_not be_completed
  end
end
