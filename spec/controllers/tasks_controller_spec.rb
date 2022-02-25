require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  include_context 'project setup'

  describe '#show' do
    it 'responds with JSON formatted output' do
      sign_in user
      get :show, format: :json, params: { project_id: project.id, id: task.id }
      expect(response.content_type).to include 'application/json'
    end
  end

  describe '#create' do
    it 'responds with JSON formatted output' do
      sign_in user
      post :create, format: :json, params: { project_id: project.id, task: { name: 'hoge'} }
      expect(response.content_type).to include 'application/json'
    end

    it 'adds a new task to the project' do
      sign_in user
      expect {
        post :create, format: :json, params: { project_id: project.id, task: { name: 'hoge'} }
      }.to change(project.tasks, :count).by(1)
    end

    it 'requires authentication' do
      expect {
        post :create, format: :json, params: { project_id: project.id, task: { name: 'hoge'} }
      }.not_to change(project.tasks, :count)
      expect(response).to_not be_successful
    end
  end
end
