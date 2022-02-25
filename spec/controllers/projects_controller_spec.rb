require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  describe '#index' do
    context 'as an authenticated user' do
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

  describe '#new' do
    context 'as an authenticated user' do
      before do
        @user = FactoryBot.create(:user)
      end

      it 'responds successfully' do
        sign_in @user
        get :new
        expect(response).to be_successful
      end

      it 'returns a 200 status' do
        sign_in @user
        get :new
        expect(response).to have_http_status 200
      end
    end

    context 'as a guest user' do
      it 'returns a 302 response' do
        get :new
        expect(response).to have_http_status 302
      end

      it 'redirects to sign-in page' do
        get :new
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe '#edit' do
    context 'as an authorized user' do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end

      it 'responds successfully' do
        sign_in @user
        get :edit, params: { id: @project }
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
        get :edit, params: { id: @other_user_project }
        expect(response).to redirect_to root_path
      end
    end
  end

  describe '#create' do
    context 'as an authenticated user' do
      before do
        @user = FactoryBot.create(:user)
      end

      context 'with valid attributes' do
        it 'adds a project' do
          project_params = FactoryBot.attributes_for(:project)
          sign_in @user
          expect { post :create, params: { project: project_params } }.to change(@user.projects, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'does not add a project' do
          project_params = FactoryBot.attributes_for(:project, :invalid)
          sign_in @user
          expect { post :create, params: { project: project_params } }.to_not change(@user.projects, :count)
        end
      end
    end

    context 'as a guest' do
      it 'returns a 302 response' do
        project_params = FactoryBot.attributes_for(:project)
        post :create, params: { project: project_params } # ここの{}はrubyのブロックではなくハッシュ
        expect(response).to have_http_status 302
      end

      it 'redirects to the sign-in page' do
        project_params = FactoryBot.attributes_for(:project)
        post :create, params: { project: project_params }
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe '#update' do
    context 'as an authorized user' do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user) # owner: @user 外部キーを指定する
      end

      it 'updates a project' do
        sign_in @user
        project_params = FactoryBot.attributes_for(:project, name: 'updated project name')
        patch :update, params: { id: @project.id, project: project_params }
        @project.reload # データベース上の値を読み込む(デフォルトではメモリの値が使われてしまい、更新されたかどうかテストできないため)
        expect(@project.name).to eq project_params[:name]
      end
    end

    context 'as an unauthorized user' do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @other_user_project = FactoryBot.create(:project, owner: other_user) # owner: @user 外部キーを指定する
      end

      it 'does not update the project' do
        sign_in @user
        project_params = FactoryBot.attributes_for(:project, name: 'updated project name')
        patch :update, params: { id: @other_user_project.id, project: project_params }
        @other_user_project.reload
        expect(@other_user_project.name).to_not eq project_params[:name]
      end

      it 'redirects to the dashboard' do
        sign_in @user
        project_params = FactoryBot.attributes_for(:project)
        patch :update, params: { id: @other_user_project.id, project: project_params }
        expect(response).to redirect_to root_path
      end
    end

    context 'as a guest' do
      before do
        @project = FactoryBot.create(:project) # 既存のデータをupdateするためbeforeであらかじめ作成しておく
      end
      it 'returns a 302 response' do
        project_params = FactoryBot.attributes_for(:project)
        patch :update, params: { id: @project.id, project: project_params }
        expect(response).to have_http_status 302
      end
      it 'redirects to  the sign-in page' do
        project_params = FactoryBot.attributes_for(:project)
        patch :update, params: { id: @project.id, project: project_params }
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe '#destroy' do
    context 'as an authorized user' do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end

      it 'deletes a project' do
        sign_in @user
        expect { delete :destroy, params: { id: @project } }.to change(@user.projects, :count).by(-1)
      end
    end

    context 'as an unauthorized user' do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @other_user_project = FactoryBot.create(:project, owner: other_user)
      end

      it 'does not delete the project' do
        sign_in @user
        expect { delete :destroy, params: { id: @other_user_project } }.to_not change(Project, :count)
      end

      it 'redirects to the dashboard' do
        sign_in @user
        delete :destroy, params: { id: @other_user_project }
        expect(response).to redirect_to root_path
      end
    end

    context 'as a guest' do
      before do
        @project = FactoryBot.create(:project)
      end

      it 'returns a 302 response' do
        delete :destroy, params: { id: @project }
        expect(response).to have_http_status 302
      end

      it 'redirects to the sign-in page' do
        delete :destroy, params: { id: @project }
        expect(response).to redirect_to '/users/sign_in'
      end

      it 'does not delete the project' do
        expect { delete :destroy, params: { id: @project } }.to_not change(Project, :count)
      end
    end
  end
end
