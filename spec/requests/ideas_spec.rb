require 'rails_helper'

RSpec.describe 'Ideas', type: :request do
  describe 'GET #index' do
    before do
      @first_idea = FactoryBot.create(:idea)
      @second_idea = FactoryBot.create(:idea)
      @first_idea_response_data = {
        'id' => @first_idea.id,
        'category' => @first_idea.category.name,
        'body' => @first_idea.body,
        'created_at' => @first_idea.created_at.to_i
      }
      @second_idea_response_data = {
        'id' => @second_idea.id,
        'category' => @second_idea.category.name,
        'body' => @second_idea.body,
        'created_at' => @second_idea.created_at.to_i
      }
    end
    context '正常なレスポンス' do
      it 'category_nameを指定しないと、全てのideaを取得できる' do
        get ideas_path, params: {}
        data = JSON.parse(response.body)['data']
        expect(response.status).to eq 200
        expect(data.length).to eq 2
        expect(data).to include(@first_idea_response_data)
      end
      it 'category_nameが空欄だと、全てのideaを取得できる' do
        get ideas_path, params: { category_name: '' }
        data = JSON.parse(response.body)['data']
        expect(response.status).to eq 200
        expect(data.length).to eq 2
        expect(data).to include(@first_idea_response_data)
      end
      it 'category_nameを指定すると、そのカテゴリーのideaを取得できる' do
        get ideas_path, params: { category_name: @first_idea.category.name }
        data = JSON.parse(response.body)['data']
        expect(response.status).to eq 200
        expect(data.length).to eq 1
        expect(data).to include(@first_idea_response_data)
        expect(data).to_not include(@second_idea_response_data)
      end
    end
    context 'エラーレスポンス' do
      it 'category_nameが存在しないと、404エラーが返ってくる' do
        get ideas_path, params: { category_name: 'wrong_category' }
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
