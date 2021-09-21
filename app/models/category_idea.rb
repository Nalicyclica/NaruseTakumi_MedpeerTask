class CategoryIdea
  include ActiveModel::Model
  attr_accessor :name, :body

  with_options presence: true do
    validates :name
    validates :body
  end

  def save
    return false unless valid?

    ActiveRecord::Base.transaction do
      category = Category.find_or_initialize_by(name: name)
      category.save!
      idea = Idea.new(body: body, category_id: category.id)
      idea.save!
    end
    true
  rescue StandardError => e
    add_errors(e)
    false
  end

  private

  def add_errors(e)
    e.record.errors.messages.each do |key, values|
      values.each do |value|
        errors.add(key, value)
      end
    end
  end
end
