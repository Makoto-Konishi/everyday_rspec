require 'rails_helper'

RSpec.describe User, type: :model do
  # 姓、名、メール、パスワードがあれば有効な状態であること
  it 'is valid with a first name, last name, email, and password' do
    user = User.new(first_name: 'Adron', last_name: 'Sumner', email: 'tester@example.com', password: 'dottle-nouveau-pav')
    expect(user).to be_valid
  end

  # 名がなければ無効な状態であること
  it 'is invalid without a first name' do
    user = User.new(first_name: '')
    user.valid? # validがfalse, またはinvalidがtrueでないとerrorsにバリデーションメッセージは格納されないので、valid?を明示している
    expect(user.errors[:first_name]).to include("can't be blank")
  end
  # 姓がなければ無効な状態であること
  it 'is invalid without a last name' do
    user = User.new(last_name: '')
    user.valid?
    expect(user.errors[:last_name]).to include("can't be blank")
  end
  # メールアドレスがなければ無効な状態であること
  it 'is invalid without an email address' do
    user = User.new(email: '')
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end
  # 重複したメールアドレスなら無効な状態であること
  it 'is invalid with a duplicate email address' do
    User.create(first_name: 'hoge', last_name: 'fuga', email: 'hoge@example.com', password: 'password')
    user = User.new(first_name: 'hoge', last_name: 'fuga', email: 'hoge@example.com', password: 'password')
    user.valid?
    expect(user.errors[:email]).to include('has already been taken')
  end
  # ユーザーのフルネームを文字列として返すこと
  it 'returns a full name as a string' do
    user = User.new(first_name: 'hoge', last_name: 'fuga', email: 'hoge@example.com', password: 'password')
    expect(user.name).to eq 'hoge fuga'
  end
end

