class ProductTag
  include Mongoid::Document
  include Mongoid::Timestamps

  has_and_belongs_to_many :product

  field :tag, type: String

  index({ tag: 1 }, { unique: true })
end
