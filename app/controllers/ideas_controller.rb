class IdeasController < ApplicationController
  def index
    response_data = select_ideas
    if response_data
      render json: {data: response_data}
    else
      render status: 404, json: ["Category doesn't exist"]
    end
  end

  def create
    categoryIdea = CategoryIdea.new(idea_params)
    if categoryIdea.save
      render status: 201, json: categoryIdea
    else
      render status: 422, json: categoryIdea.errors.full_messages
    end
  end

  private

  def idea_params
    params_keys = [:category_name, :body]
    permit_params = params.permit(params_keys)
    { name: permit_params[:category_name], body: permit_params[:body] }
  end

  def select_ideas
    if params[:category_name].present?
      category = Category.find_by(name: params[:category_name])
      # category = Category.where(name: params[:category_name]).limit(1)
      if category.present?
      # if category != []
        ideas = Idea.where(category_id: category.id).eager_load(:category).select('categories.name')
        # ideas = Idea.joins("INNER JOIN (#{category.to_sql}) category ON ideas.category_id = category.id").select('ideas.*','UNIX_TIMESTAMP(ideas.created_at) as created_utime','category.name')
      else
        return false
      end
    else
      ideas = Idea.eager_load(:category).select('categories.name')
    end
    response_data = []
    ideas.each do |idea|
      item = {
        id: idea["id"],
        category: idea["name"],
        body: idea["body"],
        created_at: idea["created_at"].to_i
      }
      response_data << item
    end
    return response_data
  end
end
