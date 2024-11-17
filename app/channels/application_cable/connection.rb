# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    protected

    # #before adding github login
    # def find_verified_user
    #   if (verified_user = User.find_by(id: cookies.signed["user.id"]))
    #     verified_user
    #   elsif (verified_user = env["warden"].user)
    #     reject_unauthorized_connection
    #   end
    # end

    #after adding github login
    def find_verified_user
      if verified_user = User.find_by(id: cookies.signed["user.id"])
        verified_user
      elsif env["warden"].user # Fallback to Devise's Warden
        env["warden"].user
      else
        reject_unauthorized_connection
      end
    end
  end
end
