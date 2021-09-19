require 'rails_helper'

RSpec.describe 'Ideas', type: :request do
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
