class CategoryIdea
  include ActiveModel::Model
  attr_accessor :name, :body

  with_options presence: true do
    validates :name
    validates :body
  end

  def save
    return false if !valid?
    category = category_exist_or_not()
    category = Category.create(name: name) if !category
    idea_create(category.id)
  end
  
  private

  def category_exist_or_not
    return Category.find_by(name: name)
  end
  
  def idea_create(category_id)
    if Idea.create(body: body, category_id: category_id)
      return true
    else
      errors.add(:base, "不正なカテゴリーです")
      return false
    end
  end
end