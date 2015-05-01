require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products

  def new_product(image_url)
  	Product.new(title: 'Dell inspiron 1545', 
  		description: 'Too slow', 
  		price: 1, 
  		image_url: image_url)
  end

  test "product attributes must be not empty" do
  	product = Product.new
  	assert product.invalid?
  	assert product.errors[:title].any?
  	assert product.errors[:description].any?
  	assert product.errors[:price].any?
  	assert product.errors[:image_url].any?
  end

  test "product price must be positive" do
  	product = Product.new(title: 'Nootebook with more characters', 
				  		  description: "Just another notebook...", 
				  		  image_url: "some_image.jpg")
  	price_validation_message = ["must be greater than or equal to 0.01"]

  	product.price = -1
  	assert product.invalid?
  	assert_equal price_validation_message, product.errors[:price]

  	product.price = 0
  	assert product.invalid?
  	assert_equal price_validation_message, product.errors[:price]

  	product.price = 1
  	assert product.valid?
  end

  test "image url" do
  	ok = %w{insp1545.jpg insp1545.gif insp1545.png INSP1545.jpg INSP1545.gif INSP1545.png 
  		http://somedomain.com/image.gif}
  	bad = %w{insp.doc insp.gif/more insp.gif.more}
  	ok.each do |image_name|
  		assert new_product(image_name).valid?, "#{image_name} should be valid"
  	end

  	bad.each do |image_name|
  		assert new_product(image_name).invalid?, "#{image_name} should not be vaalid"
  	end
  end

  test "product is not valid without a unique name" do
  	product = Product.new(title: products(:insp1545).title,
  		description: 'this is just another description',
  		price: 2500.00,
  		image_url: 'someimage.jpg')
  	assert product.invalid?
  	assert_equal ["has already been taken"], product.errors[:title]
  end
end
