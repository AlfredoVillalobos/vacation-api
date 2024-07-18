class Vacation < ApplicationRecord
  extend FilterableModel
  belongs_to :user

  enum status: { pending: 0, approved: 1, rejected: 2 }

  STATUS = { pending: 'Pendiente', approved: 'Aprobado', rejected: 'Rechazado' }

  validates :start_date, :end_date, presence: true

  # quantity of records per page
  paginates_per 10
  max_pages 100

  class << self
    def filter_proxy = Filters::VacationFilterProxy
  end

  def status_label
    STATUS[status.to_sym]
  end
  
  def days
    (end_date - start_date).to_i + 1
  end
end
