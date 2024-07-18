module V1
  class APIController < ApplicationController
    before_action :current_user

    private

      def current_user
        if !bearer_token.present?
          render json: { errors: ["No Bearer Token."] }, status: :unauthorized and return
        end

        if !decoded_jwt[:success]
          render json: { errors: decoded_jwt[:errors] }, status: :unprocessable_entity and return
        end

        user_result = find_or_create_user(current_user_profile)
        if !user_result[:success]
          render json: { errors: user_result[:errors] }, status: :unprocessable_entity and return
        end

        return user_result[:data]
      end

      def find_or_create_user(user_profile)
        @user_result ||= ::Kinde::Services::FindOrCreateUser.new({
          user_profile: user_profile,
        }).perform
      end

      def current_user_profile
        @user_profile ||= ::Kinde::Services::GetDataUser.new({bearer_token: bearer_token}).perform
        return @user_profile[:data] if @user_profile[:success]
        return nil
      end

      def bearer_token
        @bearer_token ||= request.headers["Authorization"]&.match(/Bearer (.*)/)&.[](1)
      end

      def decoded_jwt
        @decoded_jwt ||= Kinde::DecodeJwt.new({ token: bearer_token }).perform
      end

      def current_user_scope
        decoded_jwt[:scope]
      end
  end
end