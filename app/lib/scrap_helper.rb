require 'net/http'
require 'json'

module ScrapHelper
  def product_json(url)
    uri = URI(url) rescue nil
    return uri if uri.nil?

    uri.path = uri.path + ".json"
    request = Net::HTTP::Get.new(uri.to_s)

    begin
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: true, read_timeout: 20) { |http| http.request(request) }
    rescue Socket::ResolutionError
      nil
    rescue Net::ReadTimeout
      nil
    rescue OpenSSL::SSL::SSLError
      response = Net::HTTP.start(uri.host, uri.port, read_timeout: 20) { |http| http.request(request) }
      response.body
    else
      response.body
    end
  end

  def variant_hash(variant)
    variant["variant_id"] = variant.delete "id"
    variant["variant_created_at"] = variant.delete "created_at"
    variant["variant_updated_at"] = variant.delete "updated_at"
    variant
  end

  def option_hash(option)
    option["option_id"] = option.delete "id"
    option
  end

  def image_hash(image)
    image["product_image_created_at"] = image.delete "created_at"
    image["product_image_updated_at"] = image.delete "updated_at"
    image["image_id"] = image.delete "id"
    image
  end

  def scrap_create(url)
  product_raw = product_json(url)
    if product_raw.nil?
      return nil
    end

    product_hash = JSON.parse(product_raw)["product"] rescue nil
    return nil if product_hash.nil?

    url_doc = ProductUrl.new(url: params[:query])

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

    return product.product_id
  end
end
