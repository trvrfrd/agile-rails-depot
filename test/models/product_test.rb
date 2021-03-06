require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  setup { @product = products(:ruby) }

  test 'product attributes must not be empty' do
    blank_product = Product.new
    assert blank_product.invalid?
    assert blank_product.errors[:title].present?
    assert blank_product.errors[:description].present?
    assert blank_product.errors[:price].present?
    assert blank_product.errors[:image_url].present?
  end

  test 'product price must be positive' do
    @product.price = -1
    assert @product.invalid?
    assert_equal ['must be greater than or equal to 0.01'], @product.errors[:price]

    @product.price = 0
    assert @product.invalid?
    assert_equal ['must be greater than or equal to 0.01'], @product.errors[:price]

    @product.price = 1
    assert @product.valid?
  end

  test 'image url' do
    ok = %w[fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://a.b.c/x/y/z/fred.gif]
    bad = %w[fred.doc fred.gif/more fred.gif.more]

    def product_with_image_url(image_url)
      @product.image_url = image_url
      @product
    end

    ok.each do |url|
      assert product_with_image_url(url).valid?, "#{url} should be valid"
    end

    bad.each do |url|
      assert product_with_image_url(url).invalid?, "#{url} should be invalid"
    end
  end

  test 'product title must be unique' do
    product = Product.new(title:       products(:ruby).title,
                          description: 'abc',
                          price:       1,
                          image_url:   'fred.gif')
    assert product.invalid?
    assert_equal [I18n.translate('errors.messages.taken')], product.errors[:title]
  end

  test 'product title must be at least 10 characters' do
    @product.title = 'Short'
    assert @product.invalid?
    assert_equal ['is too short (minimum is 10 characters)'], @product.errors[:title]
  end

  test 'product that is in a cart cannot be destroyed' do
    product = products(:one)
    assert product.line_items.present?
    assert_not product.destroy
    assert product.errors[:base].include? 'Line Items present'
  end

  test 'product locale must be an available locale' do
    bogus_locale = 'xx'
    assert_not I18n.available_locales.map(&:to_s).include?(bogus_locale)
    @product.locale = bogus_locale
    assert @product.invalid?
    assert_equal ['is not included in the list'], @product.errors[:locale]
  end
end
