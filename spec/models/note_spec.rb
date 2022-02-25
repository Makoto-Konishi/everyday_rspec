require 'rails_helper'

RSpec.describe Note, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project) }

  # ユーザー、プロジェクト、メッセージがあれば有効な状態であること
  it 'is valid with a user, project, and message' do
    note = FactoryBot.build(:note, user:, project:)
    expect(note).to be_valid
  end

  # メッセージがなければ無効な状態であること
  it 'is invalid without a message' do
    note = FactoryBot.build(:note, message: '', user:, project:)
    note.valid?
    expect(note.errors[:message]).to include("can't be blank")
  end

  # 文字列に一致するメッセージを検索する
  describe 'search message for a term' do
    let!(:note1) { FactoryBot.create(:note, message: 'This is the first note.', user:, project:) }
    let!(:note2) { FactoryBot.create(:note, message: 'This is the second note.', user:, project:) }
    let!(:note3) { FactoryBot.create(:note, message: 'First, preheat the oven.', user:, project:) }

    # 一致するデータが見つかるとき
    context 'when a match is found' do
      it 'returns notes that match the search term' do
        expect(Note.search('first')).to include(note1, note3)
      end
    end

    # 一致するデータが見つからないとき
    context 'when no match is found' do
      it 'returns an empty collection' do
        expect(Note.search('hoge')).to be_empty
        expect(Note.count).to eq 3
      end
    end
  end

end
