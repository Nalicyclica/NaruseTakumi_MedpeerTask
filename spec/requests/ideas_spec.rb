require 'rails_helper'

RSpec.describe 'Ideas', type: :request do
  describe 'GET #index' do
    before do
      @item_number = 5
      @categories = []
      @ideas = []
      @item_number.times do |i|
        category = Category.create(name: "rpsec_test_#{i}")
        @categories << category
        @item_number.times do |j|
          @ideas << FactoryBot.create(:idea, category_id: category.id)
        end
      end 
      @expected_data = {
        'id' => @ideas[0].id,
        'category' => @categories[0].name,
        'body' => @ideas[0].body,
        'created_at' => @ideas[0].created_at.to_i
      }
      @unexpected_data = {
        'id' => @ideas[@item_number].id,
        'category' => @categories[1].name,
        'body' => @ideas[@item_number].body,
        'created_at' => @ideas[@item_number].created_at.to_i
      }
    end
    context '正常なレスポンス' do
      it 'category_nameを指定しないと、全てのideaを取得できる' do
        get ideas_path, params: {}
        data = JSON.parse(response.body)["data"]
        expect(data.length).to eq @item_number * @item_number
        expect(data).to include(@expected_data)
      end
      it 'category_nameが空欄だと、全てのideaを取得できる' do
        get ideas_path, params: {category_name: ""}
        data = JSON.parse(response.body)["data"]
        expect(data.length).to eq @item_number * @item_number
        expect(data).to include(@expected_data)
      end
      it 'category_nameを指定すると、そのカテゴリーのideaを取得できる' do
        get ideas_path, params: {category_name: @categories[0].name}
        data = JSON.parse(response.body)["data"]
        expect(data.length).to eq @item_number
        expect(data).to include(@expected_data)
        expect(data).to_not include(@unexpected_data)
      end
    end
    context 'エラーレスポンス' do
      it 'category_nameが存在しないと、404エラーが返ってくる' do
        get ideas_path, params: {category_name: "wrong_category"}
        expect(response.status).to eq 404
      end
    end
  end
  describe 'POST #create' do
    before do
      @params = {
        category_name: Faker::Lorem.word,
        body: Faker::Lorem.sentence
      }
    end
    context '正常なレスポンス' do
      it '正しい情報を投稿すると、正常なレスポンスが返ってくる' do
        post ideas_path, params: @params
        expect(response.status).to eq 201
      end
    end
    context 'エラーレスポンス' do
      it 'category_nameが空だと、レスポンスが返ってくる' do
        @params[:category_name] = ''
        post ideas_path, params: @params
        expect(response.status).to eq 422
      end
      it 'bodyが空だと、レスポンスが返ってくる' do
        @params[:body] = ''
        post ideas_path, params: @params
        expect(response.status).to eq 422
      end
    end
  end
end
