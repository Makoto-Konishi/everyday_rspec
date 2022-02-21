require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  describe '#index' do
    context 'as a authenticated user' do
      before do
        @user = FactoryBot.create(:user)
      end

      it 'responds successfully' do
        sign_in @user # spec/rails_helper.rbでDevise::Test::ControllerHelpersを取り込んでいるので、deviseのメソッドであるsign_inメソッドが使える
        get :index
        expect(response).to be_successful
      end

      it 'returns a 200 status' do
        sign_in @user
        get :index
        expect(response).to have_http_status 200
      end
    end

    context 'as a guest user' do
      it 'returns a 302 response' do
        get :index
        expect(response).to have_http_status 302
      end

      it 'redirects to sign-in page' do
        get :index
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe '#show' do
    context 'as an authorized user' do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end

      it 'responds successfully' do
        sign_in @user
        get :show, params: { id: @project }
        expect(response).to be_successful
      end
    end

    context 'as an unauthorized user' do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @other_user_project = FactoryBot.create(:project, owner: other_user)
      end

      it 'redirects to the dashboard' do
        sign_in @user
        get :show, params: { id: @other_user_project }
        expect(response).to redirect_to root_path
      end
    end
  end
end
