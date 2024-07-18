module V1
  class VacationsController < APIController

    def index
      @vacations = Vacation.all.page params[:page]

      render json: { 
                      total_page: @vacations.total_pages,
                      current_page: @vacations.current_page,
                      next_page: @vacations.next_page,
                      prev_page: @vacations.prev_page,
                      vacations: @vacations 
                  }
    end

    def show
      vacation = Vacation.find_by(id: params[:id])

      render json: { 
                      errors: {
                        message: "not found",
                      }
                    }, status: :not_found and return if vacation.blank?
      
      render json: { vacation: vacation }
    end
    
    def create
      vacation = Vacation.new(vacation_params)

      if vacation.save
        render json: { vacation: vacation }, status: :created
      else
        render json: { errors: vacation.errors.full_messages }
      end
    end

    def update
      vacation = Vacation.find(params[:id])

      if vacation.update(vacation_params)
        render json: { vacation: vacation }
      else
        render json: { errors: vacation.errors.full_messages }
      end
    end

    def destroy
      vacation = Vacation.find(params[:id])

      if vacation.destroy
        render status: :no_content
      else
        render json: { errors: vacation.errors.full_messages }
      end
    end

    def vacation_have_by_user
      vacations = Vacation.filter_by(vacations_have_by_user: params[:user_id])

      render json: { vacations: vacations }
    end

    def vacation_had_by_user
      vacations = Vacation.filter_by(vacation_had_by_user: params[:user_id])

      render json: { vacations: vacations }
    end

    private

      def vacation_params
        params.require(:vacation).permit(:user_id, :start_date, :end_date)
      end
  end
end
