require 'rails_helper'

RSpec.describe Category, type: :model do
  before do
    @category = FactoryBot.build(:category)
  end
  describe '新しいカテゴリーの登録' do
    context '新しいカテゴリーを登録できる時' do
      it '正しい情報なら新しいカテゴリーを登録できる' do
        expect(@category).to be_valid
      end
    end
    context '新しいカテゴリーを登録できない時' do
      it 'nameがないと登録できない' do
        @category.name = ''
        @category.valid?
        expect(@category.errors.full_messages).to include("Name can't be blank")
      end
      it 'nameが重複すると登録できない' do
        FactoryBot.create(:category, name: @category.name)
        @category.valid?
        expect(@category.errors.full_messages).to include('Name has already been taken')
      end
    end
  end
end
