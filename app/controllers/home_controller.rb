# frozen_string_literal: true

class HomeController < ApplicationController
  include ShopifyApp::EmbeddedApp
  include ShopifyApp::DomainProtection

  def index
    @shop_origin = current_shopify_domain
  end
end

