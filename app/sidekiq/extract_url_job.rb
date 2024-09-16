require 'net/http'
require 'json'
require 'sidekiq-scheduler'

class ExtractUrlJob
  include Sidekiq::Job
  include ScrapHelper

  def add_new_product(product_hash, url)
    url_doc = ProductUrl.new(url: url)

    tags_string = product_hash["tags"].present? ? product_hash["tags"].split(",") : nil
    tags = tags_string.nil? ? tags_string : tags_string.map { |tag| ProductTag.find_or_create_by({tag: tag.strip}) }

    product = Product.new(
      title: product_hash["title"],
      body_html: product_hash["body_html"],
      vendor: product_hash["vendor"],
      product_type: product_hash["product_type"],
      product_created_at: product_hash["created_at"],
      product_updated_at: product_hash["updated_at"],
      product_published_at: product_hash["published_at"],
      handle: product_hash["handle"],
      template_suffix: product_hash["template_suffix"],
      published_scope: product_hash["published_scope"],
      product_id: product_hash["id"],
      product_url: url_doc,
      product_tag: tags,
    )

    product.variants = product_hash["variants"].map { |variant| variant_hash(variant) }
    product.options = product_hash["options"].map { |option| option_hash(option) }
    product.images = product_hash["images"].map { |image| image_hash(image) }

    product.save
    url_doc.save
    # product.update_attribute(:product_tag, tags)
  end

  def update_product(product_hash)
  end

  def perform(url = nil)
    product_raw = product_json(url)
    if product_raw.nil?
      return nil
    end

    product_hash = JSON.parse(product_raw)["product"] rescue nil
    return nil if product_hash.nil?

    add_new_product(product_hash, url)
  end
end
