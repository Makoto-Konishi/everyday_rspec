require 'rails_helper'

RSpec.describe User, type: :model do
  # 姓、名、メール、パスワードがあれば有効な状態であること
  it 'is valid with a first name, last name, email, and password' do
    user = FactoryBot.build(:user)
    expect(user).to be_valid
  end

  # 名がなければ無効な状態であること
  it 'is invalid without a first name' do
    user = FactoryBot.build(:user, first_name: '')
    user.valid? # validがfalse, またはinvalidがtrueでないとerrorsにバリデーションメッセージは格納されないので、valid?を明示している
    expect(user.errors[:first_name]).to include("can't be blank")
  end

  # 姓がなければ無効な状態であること
  it 'is invalid without a last name' do
    user = FactoryBot.build(:user, last_name: '')
    user.valid?
    expect(user.errors[:last_name]).to include("can't be blank")
  end

  # メールアドレスがなければ無効な状態であること
  it 'is invalid without an email address' do
    user = FactoryBot.build(:user, email: '')
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  # 重複したメールアドレスなら無効な状態であること
  it 'is invalid with a duplicate email address' do
    FactoryBot.create(:user, email: 'hoge@example.com')
    user = FactoryBot.build(:user, email: 'hoge@example.com')
    user.valid?
    expect(user.errors[:email]).to include('has already been taken')
  end

  # ユーザーのフルネームを文字列として返すこと
  it 'returns a full name as a string' do
    user = FactoryBot.build(:user)
    expect(user.name).to eq "#{user.first_name} #{user.last_name}"
  end
end

