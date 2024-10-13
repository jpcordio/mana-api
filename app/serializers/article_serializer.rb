class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :image

  belongs_to :user
end
