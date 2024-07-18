module Kinde
  module Services
    class FindOrCreateUser
      PROVIDER_KEY = "kinde"

      def initialize(params = {})
        @user_profile = params[:user_profile]
      end

      def perform
        user_result = find_or_create_user(@user_profile)
        return user_result
      end

      private

        def find_or_create_user(user_profile)
          # Existing User
          existing_user = User.joins(:user_accounts)
            .where(user_accounts: {
              provider: PROVIDER_KEY,
              provider_account_id: user_profile&.dig(:id),
            })
            .first
          return { success: true, data: existing_user } if existing_user

          # New User
          new_user = User.new(
            email: user_profile&.dig(:preferred_email),
            name: "#{user_profile&.dig(:first_name)} #{user_profile&.dig(:last_name)}",
            user_accounts_attributes: [{
              provider: PROVIDER_KEY,
              provider_account_id: user_profile&.dig(:id),
            }],
          )

          return { success: false, errors: new_user.errors.full_messages } if !new_user.save

          return { success: true, data: new_user }
        end
    end
  end
end