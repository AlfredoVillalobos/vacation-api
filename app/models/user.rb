class User < ApplicationRecord
  extend FilterableModel
  
  has_many :user_accounts, dependent: :destroy
  has_many :vacations, dependent: :destroy
  belongs_to :leader, optional: true

  accepts_nested_attributes_for :user_accounts
  accepts_nested_attributes_for :vacations

  validates :name, presence: true
  validates :email, format: { with: /\A[\w\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i }, on: %i[create update]

  #quantity of records per page
  paginates_per 10
  max_pages 100

  class << self
    def filter_proxy = Filters::UserFilterProxy
  end
  
  def vacation_had_days_per_year
    vacations.approved
      .order(:start_date)
      .group_by { |vacation| vacation.start_date.year }
      .transform_values { |vacations| vacations.sum(&:days) }
  end
end
