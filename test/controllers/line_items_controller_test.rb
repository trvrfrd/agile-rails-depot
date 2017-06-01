require 'test_helper'

class LineItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @line_item = line_items(:one)
  end

  test "should get index" do
    get line_items_url
    assert_response :success
  end

  test "should get new" do
    get new_line_item_url
    assert_response :success
  end

  test "should create line_item" do
    assert_difference('LineItem.count') do
      post line_items_url, params: { product_id: products(:ruby).id }
    end
    assert_redirected_to store_index_url
  end

  test "should create line_item via ajax" do
    assert_difference('LineItem.count') do
      post line_items_url, params: { product_id: products(:ruby).id }, xhr: true
    end
    assert_response :success
    assert_select_jquery :html, '#cart' do
      assert_select 'tr#current-item td', products(:ruby).title
    end
  end

  test "should show line_item" do
    get line_item_url(@line_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_line_item_url(@line_item)
    assert_response :success
  end

  test "should update line_item" do
    patch line_item_url(@line_item), params: { line_item: { product_id: @line_item.product_id } }
    assert_redirected_to line_item_url(@line_item)
  end

  test 'should decrement line_item quantity' do
    @line_item.update(quantity: 2)
    patch decrement_line_item_url(@line_item)
    assert_equal 1, @line_item.reload.quantity
    assert_redirected_to store_index_url
  end

  test 'should decrement line_item quantity via ajax' do
    # janky(?) way to set up the session so we have a cart with stuff to display
    post line_items_url, params: { product_id: products(:ruby).id }
    @line_item = LineItem.last
    @line_item.update(quantity: 70)

    patch decrement_line_item_url(@line_item), xhr: true
    assert_select_jquery :html, '#cart' do
      # 00d7 == multiplication sign
      assert_select 'tr#current-item td', "69 \u00d7"
      assert_select 'tr#current-item td', products(:ruby).title
    end
  end

  test 'should destroy line_item when decrementing quantity to 0' do
    # fixture's quantity/default quantity is 1
    assert_difference('LineItem.count', -1) do
      patch decrement_line_item_url(@line_item)
    end
    assert_redirected_to store_index_url
  end

  test "should destroy line_item" do
    assert_difference('LineItem.count', -1) do
      delete line_item_url(@line_item)
    end
    assert_redirected_to store_index_url
  end
end
