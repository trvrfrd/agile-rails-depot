require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper
  fixtures :products

  test 'buying a product' do
    start_order_count = Order.count
    ruby_book = products(:ruby)

    get store_index_url
    assert_response :success
    assert_select 'h1', 'Your Pragmatic Catalog'

    post line_items_url, params: { product_id: ruby_book.id }, xhr: true
    assert_response :success

    cart = Cart.find(session[:cart_id])
    assert_equal 1, cart.line_items.size
    assert_equal ruby_book, cart.line_items.first.product

    get new_order_url
    assert_response :success
    assert_select 'legend', 'Please Enter Your Details'

    perform_enqueued_jobs do
      post orders_url, params: {
        order: {
          name: 'Dave Thomas',
          address: '123 Street St',
          email: 'dave@example.com',
          pay_type: 'Check'
        }
      }
    end
    follow_redirect!
    assert_response :success
    assert_select 'h1', 'Your Pragmatic Catalog'
    cart = Cart.find(session[:cart_id])
    assert_equal 0, cart.line_items.size

    assert_equal start_order_count + 1, Order.count
    order = Order.last

    assert_equal 'Dave Thomas', order.name
    assert_equal '123 Street St', order.address
    assert_equal 'dave@example.com', order.email
    assert_equal 'Check', order.pay_type
    assert_equal 1, order.line_items.size
    assert_equal ruby_book, order.line_items.first.product

    mail = ActionMailer::Base.deliveries.last
    assert_equal ['dave@example.com'], mail.to
    assert_equal 'Depot App <depot@example.com>', mail[:from].value
    assert_equal 'Pragmatic Store Order Confirmation', mail.subject
  end
end
