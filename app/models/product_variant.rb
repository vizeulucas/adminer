class ProductVariant
  include Mongoid::Document
  include Mongoid::Timestamps

  # relationship uma variante para um produto
  embedded_in :product_original, class_name: "Product", inverse_of: :variants
  # relationship uma image id para uma variação de produto

  field :title, type: String
  field :price, type: String # TODO: change later to a best monetary representation
  field :sku, type: String
  field :position, type: Integer
  field :compare_at_price, type: String # TODO: change later to a best monetary representation
  field :fulfillment_service, type: String
  field :inventory_management, type: String
  field :option1, type: String
  field :option2, type: String
  field :option3, type: String
  field :variant_created_at, type: DateTime
  field :variant_updated_at, type: DateTime
  field :taxable, type: Boolean
  field :barcode, type: String
  field :grams, type: Float
  field :weight, type: Float
  field :weight_unit, type: String
  field :requires_shipping, type: String
  field :price_currency, type: String
  field :compare_at_price_currency, type: String
  field :image_id, type: Integer
  field :variant_id, type: Integer
  field :product_id, type: Integer
  field :quantity_rule, type: Object
  field :quantity_price_breaks, type: Array
end
