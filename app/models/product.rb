class Product
  include Mongoid::Document
  include Mongoid::Timestamps

  has_one :product_url
  has_and_belongs_to_many :product_tag

  embeds_many :variants, class_name: "ProductVariant", inverse_of: :product_original
  embeds_many :options, class_name: "ProductOption", inverse_of: :product
  embeds_many :images, class_name: "ProductImage", inverse_of: :product

  field :title, type: String
  field :body_html, type: String
  field :vendor, type: String
  field :product_type, type: String
  field :product_created_at, type: DateTime
  field :product_updated_at, type: DateTime
  field :product_published_at, type: DateTime
  field :handle, type: String
  field :template_suffix, type: String
  field :published_scope, type: String
  field :product_id, type: Integer

  index({ product_id: 1 }, { unique: false })

  index title: "text"
end
