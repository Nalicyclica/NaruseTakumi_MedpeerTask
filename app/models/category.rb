class Category < ApplicationRecord
  # category_ideaの記述と被るが、category.saveが呼び出された時のために、uniqueness設定はあったほうがいい？
  validates :name, presence: true, uniqueness: true
  has_many :ideas
end
