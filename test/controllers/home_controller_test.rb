# frozen_string_literal: true

require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  setup do
    @shop = Shop.create(shopify_domain: 'test.myshopify.io', shopify_token: '12345')
    @login_url = ShopifyApp.configuration.login_url
  end

  test '#index: renders invalid_shop if shop parameter is missing' do
    get '/'

    assert_template :invalid_shop
  end

  test '#index: renders invalid_shop if shop is on an invalid domain' do
    different_shop_domain = 'https://anothershop.blah.com'

    get '/', params: { shop: different_shop_domain }

    assert_template :invalid_shop
  end

  test '#index: redirects to login if the shop is not installed' do
    uninstalled_shop_domain = 'https://notinstalled.myshopify.io'

    get '/', params: { shop: uninstalled_shop_domain }

    assert_redirected_to "/login?shop=#{uninstalled_shop_domain}"
  end

  test '#index: renders  '\
    ' shop parameter matches the installed shop' do

    get '/', params: { shop: @shop.shopify_domain }

    assert_template :index
  end
end
