require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products

  test 'product attributes must not be empty' do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].present?
    assert product.errors[:description].present?
    assert product.errors[:price].present?
    assert product.errors[:image_url].present?
  end

  test 'product price must be positive' do
    product = Product.new(title:       'Book Title',
                          description: 'abc',
                          image_url:   'xyz.jpg')
    product.price = -1
    assert product.invalid?
    assert_equal ['must be greater than or equal to 0.01'], product.errors[:price]

    product.price = 0
    assert product.invalid?
    assert_equal ['must be greater than or equal to 0.01'], product.errors[:price]

    product.price = 1
    assert product.valid?
  end

  def new_product(image_url)
    Product.new(title:       'Book Title',
                description: 'abc',
                price:       1,
                image_url:   image_url)
  end

  test 'image url' do
    ok = %w[fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://a.b.c/x/y/z/fred.gif]
    bad = %w[fred.doc fred.gif/more fred.gif.more]

    ok.each do |url|
      assert new_product(url).valid?, "#{url} shouldn't be invalid"
    end

    bad.each do |url|
      assert new_product(url).invalid?, "#{url} should be invalid"
    end
  end

  test 'product is not valid without unique title' do
    product = Product.new(title:       products(:ruby).title,
                          description: 'abc',
                          price:       1,
                          image_url:   'fred.gif')
    assert product.invalid?
    assert_equal [I18n.translate('errors.messages.taken')], product.errors[:title]
  end
end
