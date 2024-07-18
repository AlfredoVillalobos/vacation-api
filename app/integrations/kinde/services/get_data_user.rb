module Kinde
  module Services
    class GetDataUser
      def initialize(params = {})
        @token = params[:bearer_token]
      end

      def perform
        @response = get_user_data
        return success_response if @response.status.success?

        return { success: false, errors: ["Unable to get user data"] }
      rescue HTTP::Error => e
        return { success: false, errors: ["Unable to get user data"] }
      end

      
      private
        def get_user_data
          HTTP.auth("Bearer #{@token}").get(url)
        end
        
        def success_response
          data = JSON.parse(@response.to_s, symbolize_names: true)
          return { success: true, data: data }
        end

        def domain_url
          Rails.application.credentials.dig(:kinde, :domain)
        end

        def url
          "#{domain_url}/oauth2/user_profile"
        end
    end
  end
end