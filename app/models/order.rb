class Order < ApplicationRecord
  belongs_to :user
  belongs_to :sale
  has_one :address
end
