class Product < ActiveRecord::Base
	
	validates :title, :description, :image_url, presence: true
	validates :price, numericality: {greater_than_or_equal_to: 0.01}
	validates :title, uniqueness: true, length: {
		minimum: 10, 
		maximum: 100, 
		message: 'sould be at least 10 and at most 100 characters long'
	}	
	validates :image_url, allow_blank: true, format: {
		with: %r{\.(gif|jpg|png)\Z}i,
		message: 'precisa conter a url no formato GIF, PNG ou JPG'	
	}

	def self.latest 
		Product.order(:updated_at).last
	end

end