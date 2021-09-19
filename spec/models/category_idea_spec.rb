require 'rails_helper'

RSpec.describe CategoryIdea, type: :model do
  before do
    @category_idea = FactoryBot.build(:category_idea)
  end
  describe '新しいアイデアの登録' do
    context '新しいアイデアを登録できる時' do
      it '正しい情報なら新しいカテゴリーのアイデアを登録できる' do
        expect(@category_idea).to be_valid
      end
      it '正しい情報なら既存カテゴリーのアイデアを登録できる' do
        @category = FactoryBot.create(:category, name: @category_idea.name)
        expect(@category_idea).to be_valid
      end
    end
    context '新しいアイデアを登録できない時' do
      it 'nameがないと登録できない' do
        @category_idea.name = ''
        @category_idea.valid?
        expect(@category_idea.errors.full_messages).to include("Name can't be blank")
      end
      it 'bodyがないと登録できない' do
        @category_idea.body = ''
        @category_idea.valid?
        expect(@category_idea.errors.full_messages).to include("Body can't be blank")
      end
    end
  end
end
