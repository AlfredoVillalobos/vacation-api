module Filters
  module VacationFilterScopes
    extend FilterScopeable
    
    filter_scope :vacations_have_by_user, -> (user_id) { 
      joins(:user)
        .where(user: { id: user_id })
        .where("start_date >= ? AND status IN (0, 1)", DateTime.parse(Date.today.to_s)) 
    }

    filter_scope :vacation_had_by_user, -> (user_id){ 
      joins(:user)
        .where(users: { id: user_id })
        .where(
          "vacations.start_date <= ? AND (vacations.end_date <= ? OR vacations.end_date > ?) AND vacations.status = ?",
          DateTime.parse(Date.today.to_s), DateTime.parse(Date.today.to_s), DateTime.parse(Date.today.to_s), 1
        )
    }
  end

  class VacationFilterProxy < FilterProxy
    def self.query_scope = Vacation
    def self.filter_scopes_module = Filters::VacationFilterScopes
  end
end