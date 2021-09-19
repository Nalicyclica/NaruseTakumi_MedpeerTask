class IdeasController < ApplicationController
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
    return {name: permit_params[:category_name], body: permit_params[:body]}
  end
end
