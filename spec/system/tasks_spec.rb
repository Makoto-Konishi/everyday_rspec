require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:project) { FactoryBot.create(:project, name: 'Test Project', owner: user) }
  let!(:task) { project.tasks.create!(name: 'A Test Task Of Test Project') }

  scenario 'user toggles a task', js: true do
    sign_in_user(user)
    go_to_project(project.name)

    complete_task(task.name)
    expect_complete_task(task.name)

    undo_complete_task(task.name)
    expect_incomplete_task(task.name)
  end

  def sign_in_user(user)
    visit root_path
    click_link 'Sign in'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'
  end

  def go_to_project(name)
    click_link name
  end

  def complete_task(name)
    check name
  end

  def undo_complete_task(name)
    uncheck name
  end

  def expect_complete_task(name)
    expect(page).to have_css "label.completed", text: name
    expect(task.reload).to be_completed
  end

  def expect_incomplete_task(name)
    expect(page).to_not have_css "label.completed", text: name
    expect(task.reload).to_not be_completed
  end
end
