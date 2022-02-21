require 'rails_helper'

RSpec.describe Project, type: :model do
  before do
    @user = FactoryBot.create(:user)
    @project = FactoryBot.create(:project)
  end

  # プロジェクト名があれば有効な状態であること
  it 'is valid with a name' do
    expect(@project).to be_valid
  end

  # プロジェクト名がなければ無効な状態であること
  it 'is invalid without a name' do
    project = FactoryBot.build(:project, name: '')
    project.valid?
    expect(project.errors[:name]).to include("can't be blank")
  end

  # ユーザー単位では重複したプロジェクト名を許可しないこと
  it 'does not allow duplicate project names per user' do # 一意性を確認すれば良いので、データをあらかじめ用意しておく
    new_project = FactoryBot.build(:project, name: @project.name, user_id: @project.user_id)
    new_project.valid?
    expect(new_project.errors[:name]).to include('has already been taken')
  end

  # 二人のユーザーが同じ名前を使うのは許可すること
  it 'allows two users to share a project name' do
    other_user = FactoryBot.create(:user, first_name: 'foo', last_name: 'fuga', email: 'foo@example.com', password: 'password')
    other_project = FactoryBot.build(:project, name: 'test project', user_id: other_user)
    expect(other_project).to be_valid
  end

  # たくさんのメモが付いていること
  it 'can have many notes' do
    project = FactoryBot.create(:project, :with_notes)
    expect(project.notes.length).to eq 5
  end

  # 遅延ステータス
  describe 'late status' do
    it 'is late when the due date is past today' do
      project = FactoryBot.create(:project, :due_yesterday)
      expect(project).to be_late
    end

    it 'is on time when the due date is today' do
      project = FactoryBot.create(:project, :due_today)
      expect(project).to_not be_late
    end

    it 'is on time when the due date is tomorrow' do
      project = FactoryBot.create(:project, :due_tomorrow)
      expect(project).to_not be_late
    end
  end
end
