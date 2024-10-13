class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :image
end
