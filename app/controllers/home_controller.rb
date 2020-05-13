# frozen_string_literal: true

class HomeController < ApplicationController
  include ShopifyApp::EmbeddedApp

  def index
#    return render(:invalid_shop) if shopify_domain.nil? || !valid_shopify_domain?
#
#    return redirect_to(shop_login) if shop.nil?
#
#    @shop_origin = shopify_domain
  end

  private

  def shopify_domain
    params[:shop]
  end

  def valid_shopify_domain?
    ShopifyApp::Utils.sanitize_shop_domain(shopify_domain).present?
  end

  def shop_login
    url = ShopifyApp.configuration.login_url
    shop = params[:shop]
    "#{url}?shop=#{shop}"
  end

  def shop
    @shop ||= Shop.find_by(shopify_domain: shopify_domain)
  end

  def shop_session_by_cookie
    return if session[:shop_id].blank?
  end

end
