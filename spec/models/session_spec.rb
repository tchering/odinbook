# spec/requests/session_spec.rb
require 'rails_helper'

RSpec.describe 'User Sessions', type: :request do
  let(:user) { create(:user) }

  describe 'User login' do
    it 'allows a user to log in with valid credentials' do
      post user_session_path, params: {
        user: {
          email: user.email,
          password: user.password
        }
      }
      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include('Signed in successfully')
    end

    it 'does not allow login with invalid credentials' do
      post user_session_path, params: {
        user: {
          email: user.email,
          password: 'wrongpassword'
        }
      }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'Protected pages' do
    it 'redirects to login when accessing protected page' do
      get posts_path
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'allows access to protected pages when signed in' do
      sign_in user
      get posts_path
      expect(response).to have_http_status(:success)
    end
  end
end
