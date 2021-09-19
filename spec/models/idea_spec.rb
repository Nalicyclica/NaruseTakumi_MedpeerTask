require 'rails_helper'

RSpec.describe Idea, type: :model do
  before do
    @category = FactoryBot.create(:category)
    @idea = FactoryBot.build(:idea, category_id: @category.id)
  end
  describe '新しいアイデアの登録' do
    context '新しいアイデアを登録できる時' do
      it '正しい情報なら新しいアイデアを登録できる' do
        expect(@idea).to be_valid
      end
    end
    context '新しいアイデアを登録できない時' do
      it 'categoryがないと登録できない' do
        @idea.category_id = nil
        @idea.valid?
        expect(@idea.errors.full_messages).to include("Category must exist")
      end
    end
  end
end
