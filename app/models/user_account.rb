class UserAccount < ApplicationRecord
  belongs_to :user
  validates :provider_account_id, :provider,  presence: true
end
