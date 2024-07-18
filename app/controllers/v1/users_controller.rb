module V1
  class UsersController < APIController

    def login
      render json: { current_user: current_user }
    end

    def index
      @users = User.all.page params[:page]

      render status: :no_content and return if @users.blank?

      render json: { 
                      total_page: @users.total_pages,
                      current_page: @users.current_page,
                      next_page: @users.next_page,
                      prev_page: @users.prev_page,
                      users: @users 
                  }
    end

    def show
      user = User.find_by(id: params[:id])
    
      render json: { 
                      errors: { 
                        message:"not found",
                      } 
                    }, status: :not_found and return if user.blank?
      
      render json: { user: user }
    end

    def create
      user = User.new(user_params)

      if user.save
        render json: { user: user }, status: :created
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      user = User.find(params[:id])

      if user.update(user_params)
        render json: { user: user }
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      user = User.find(params[:id])

      if user.destroy
        render status: :no_content
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def query_scope
      users = define_filter

      render json: { 
                      errors: {
                        message: "A parameter is needed to filter the users. You can use the following parameters: leader_id, start_date, end_date, vacation_to_take or vacation_took"
                      }
                    }, status: :unprocessable_entity and return if users.nil?

      render json: { users: users }
    end

    def vacation_per_year
      user = User.find_by(id: params[:id])

      render json: { 
                      errors: { 
                        message:"not found",
                      } 
                    }, status: :not_found and return if user.blank?

      render json: { vacation_per_year: user.vacation_had_days_per_year }
    end

    private

      def user_params
        params.require(:user).permit(:name, :email, :leader_id, vacations_attributes: [:start_date, :end_date])
      end

      def define_filter
        case
        when params.keys.include?('leader_id')
          User.filter_by(leader: params[:leader_id])
        when params.keys.include?('start_date')
          User.filter_by(vacation_start_date: params[:start_date])
        when params.keys.include?('end_date')
          User.filter_by(vacation_end_date: params[:end_date])
        when params.keys.include?('vacation_to_take')
          User.filter_by(vacation_to_take: params[:start_date])
        when params.keys.include?('vacation_took')
          User.filter_by(vacation_took: params[:start_date])
        end
      end
  end
end