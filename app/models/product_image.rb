class ProductImage
  include Mongoid::Document
  include Mongoid::Timestamps

  # relationship uma imagem para um produto
  embedded_in :product, class_name: "Product", inverse_of: :images
  # relationship varias variações de produto para uma imagem

  field :position, type: Integer
  field :product_image_created_at, type: DateTime
  field :product_image_updated_at, type: DateTime
  field :alt, type: String
  field :width, type: Integer
  field :height, type: Integer
  field :src, type: String
  field :variants_id, type: Array
  field :image_id, type: Integer
  field :product_id, type: Integer
  field :variant_ids, type: Array
end
