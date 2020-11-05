class Sale < ApplicationRecord
  belongs_to :book

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :status
  belongs_to_active_hash :transfer_fee

end
