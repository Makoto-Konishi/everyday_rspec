require 'rails_helper'

RSpec.describe Project, type: :model do
  before do
    @user = User.create(first_name: 'hoge', last_name: 'fuga', email: 'hoge@example.com', password: 'password')
    @project = @user.projects.create(name: 'test project')
  end

  # プロジェクト名があれば有効な状態であること
  it 'is valid with a name' do
    expect(@project).to be_valid
  end

  # プロジェクト名がなければ無効な状態であること
  it 'is invalid without a name' do
    project = Project.new(name: '')
    project.valid?
    expect(project.errors[:name]).to include("can't be blank")
  end

  # ユーザー単位では重複したプロジェクト名を許可しないこと
  it 'does not allow duplicate project names per user' do # 一意性を確認すれば良いので、データをあらかじめ用意しておく
    new_project = @user.projects.new(name: 'test project')
    new_project.valid?
    expect(new_project.errors[:name]).to include('has already been taken')
  end

  # 二人のユーザーが同じ名前を使うのは許可すること
  it 'allows two users to share a project name' do
    other_user = User.create(first_name: 'foo', last_name: 'fuga', email: 'foo@example.com', password: 'password')
    other_project = other_user.projects.new(name: 'test project')
    expect(other_project).to be_valid
  end
end
