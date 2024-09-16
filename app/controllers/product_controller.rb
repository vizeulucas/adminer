
class ProductController < ApplicationController
  include ScrapHelper

  def index
    page_number = params[:page_number].present? ? params[:page_number] : 1
    Mongo::QueryCache.cache do
      @products = Product.page(page_number)
    end
  end

  def show
    Mongo::QueryCache.cache do
      @product = Product.where(:product_id => params[:id]).first
    end
  end

  def search
    page_number = params[:page_number].present? ? params[:page_number] : 1
    Mongo::QueryCache.cache do
      if params[:search_by] == "title"
        @products = Product.where('$text' => {'$search' => params[:query]}).page(page_number)
      else
        @products = Product.where(params[:search_by].to_sym => params[:query]).page(page_number)
      end
    end
  end

  def new
  end

  def create
    url = params[:query]
    
    id = scrap_create(url)
    
    redirect_to :controller => 'product', :action => "show", id: id 
  end

  def destroy
    prod = Product.where(:id => params[:id]).first
    prod.product_url.delete
    prod.delete
    redirect_to :controller => 'product', :action => "index"
  end
end
