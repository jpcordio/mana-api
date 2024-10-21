class ConnectionSerializer < ActiveModel::Serializer
  attributes :id, :customer_id, :company_id
end
