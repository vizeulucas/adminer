class ProductOption
  include Mongoid::Document
  include Mongoid::Timestamps

  # relationship field uma opções para um produto
  embedded_in :product, class_name: "Product", inverse_of: :options

  field :name, type: String
  field :position, type: Integer
  field :values, type: Array # ["string"]
  field :option_id, type: Integer
  field :product_id, type: Integer
end
