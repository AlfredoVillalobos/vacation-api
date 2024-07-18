module Filters
  module UserFilterScopes
    extend FilterScopeable
    
    filter_scope :leader, ->(leader_id) { where(leader_id: leader_id) }
    filter_scope :vacation_start_date, ->(start_date) { joins(:vacations).where("vacations.start_date = ?", start_date) }
    filter_scope :vacation_end_date, ->(end_date) { joins(:vacations).where("vacations.end_date = ?", end_date) }
    filter_scope :vacation_to_take, -> (start_date) { 
      joins(:vacations)
        .where(
          "vacations.start_date >= ? AND vacations.status IN (0, 1)",
          DateTime.parse(start_date.to_s)
        ) 
    }
    filter_scope :vacation_took, -> (end_date){ 
      joins(:vacations)
        .where(
          "vacations.end_date <= ? AND vacations.status = 1",
          DateTime.parse(start_date.to_s)
        )
    }
  end

  class UserFilterProxy < FilterProxy
    def self.query_scope = User
    def self.filter_scopes_module = Filters::UserFilterScopes
  end
end