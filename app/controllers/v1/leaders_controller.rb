module V1
  class LeadersController < APIController
    # GET /v1/leaders
    def index
      @leaders = Leader.all.page params[:page]

      render json: { errors: ["No leaders found."] }, status: :not_content and return if @leaders.blank?

      render json: { 
                      total_page: @leaders.total_pages,
                      current_page: @leaders.current_page,
                      next_page: @leaders.next_page,
                      prev_page: @leaders.prev_page,
                      leaders: @leaders 
                  }
    end

    # GET /v1/leaders/:id
    def show
      leader = Leader.find(params[:id])

      render json: { leader: leader }
    end

    # POST /v1/leaders
    def create
      leader = Leader.new(leader_params)

      if leader.save
        render json: leader, status: :created
      else
        render json: { errors: leader.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # PUT /v1/leaders/:id
    def update
      leader = Leader.find(params[:id])

      if leader.update(leader_params)
        render json: { leader: leader }
      else
        render json: { errors: leader.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # DELETE /v1/leaders/:id
    def destroy
      leader = Leader.find(params[:id])

      if leader.destroy
        render status: :no_content
      else
        render json: { errors: leader.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def leader_params
      params.require(:leader).permit(:name)
    end
  end
end