require 'test_helper'

class CartsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cart = carts(:one)
  end

  test "should get index" do
    get carts_url
    assert_response :success
  end

  test "should get new" do
    get new_cart_url
    assert_response :success
  end

  test "should create cart" do
    assert_difference('Cart.count') do
      post carts_url, params: { cart: {  } }
    end

    assert_redirected_to cart_url(Cart.last)
  end

  test "should show cart" do
    get cart_url(@cart)
    assert_response :success
    assert_select 'h2', 'Your Cart'
    @cart.line_items.each do |item|
      assert_select 'td', item.product.title
      # Remove from Cart button
      assert_select %(form[action="#{line_item_path(item)}"])
    end
  end

  test "should redirect rather than throw error when showing invalid cart id" do
    get cart_url(id: "I'm doing something malicious")
    assert_redirected_to store_index_url
  end

  test "should get edit" do
    get edit_cart_url(@cart)
    assert_response :success
  end

  test "should update cart" do
    patch cart_url(@cart), params: { cart: {  } }
    assert_redirected_to cart_url(@cart)
  end

  test "should destroy cart" do
    post line_items_url, params: { product_id: products(:ruby).id }
    @cart = Cart.find(session[:cart_id])

    assert_difference('Cart.count', -1) do
      delete cart_url(@cart)
    end

    assert_redirected_to store_index_url
  end

  test 'should destroy cart via ajax' do
    post line_items_url, params: { product_id: products(:ruby).id }
    @cart = Cart.find(session[:cart_id])

    assert_difference('Cart.count', -1) do
      delete cart_url(@cart), xhr: true
    end
    assert_response :success
    assert_select_jquery :html, '#cart' do
      assert_select 'tr > td.item-price', count: 0
    end
  end
end
