require 'sidekiq-scheduler'

class VerifyProductsJob
  include Sidekiq::Job
  include ScrapHelper

  def perform()
    ProductUrl.all.each do |url|
      puts "updating #{url.url}"

      product_raw = product_json(url.url)
      if product_raw.nil?
        return nil
      end

      product_hash = JSON.parse(product_raw)["product"] rescue nil
      return nil if product_hash.nil?

      tags_string = product_hash["tags"].present? ? product_hash["tags"].split(",") : nil
      tags = tags_string.nil? ? tags_string : tags_string.map { |tag| ProductTag.find_or_create_by({tag: tag.strip}).id }

      product = Product.where(id: url.product_id)
      product.update(
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
        variants: product_hash["variants"].map { |variant| variant_hash(variant) },
        options: product_hash["options"].map { |option| option_hash(option) },
        images: product_hash["images"].map { |image| image_hash(image) },
      )
      product.update(product_tag_ids: tags)

      puts "#{url.url} updated"
    end
  end
end
