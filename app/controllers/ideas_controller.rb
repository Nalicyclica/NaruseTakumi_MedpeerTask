class IdeasController < ApplicationController
  def index
    ideas = select_ideas
    if ideas
      render json: {data: ideas_to_response_data(ideas)}
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
    return ideas = Idea.eager_load(:category).select('categories.name') if params[:category_name].blank?
    category = Category.find_by(name: params[:category_name])
    if category.present?
      return ideas = Idea.where(category_id: category.id).eager_load(:category).select('categories.name')
    else
      return false
    end
  end
  
  def ideas_to_response_data(ideas)
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
