class ProductUrl
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :product

  field :url, type: String

  index({ url: 1 }, { unique: true })
end
