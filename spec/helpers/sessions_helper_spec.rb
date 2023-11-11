require 'spec_helper'
require 'rails_helper'

describe SessionsHelper, type: :helper do
  let(:user) {
    User.create!(
      username: 'current_user',
      password: 'current_user_password',
      password_confirmation: 'current_user_password',
      email: 'current_user_email@test.com',
      phone_number: '1234567890'
    )
  }

  describe '#log_in' do
    it 'stores the user id in the session' do
      log_in(user)
      expect(session[:user_id]).to eq(user.id)
    end
  end

  describe '#current_user' do
    it 'returns the user from the session' do
      session[:user_id] = user.id
      expect(current_user).to eq(user)
    end
  end

  describe '#logged_in?' do
    it 'returns true when the user is logged in' do
      log_in(user)
      expect(logged_in?).to be true
    end

    it 'returns false when the user is not logged in' do
      session[:user_id] = nil
      expect(logged_in?).to be false
    end
  end

  describe '#log_out' do
    it 'removes the user id from the session and clears the current user' do
      log_in(user)
      log_out
      expect(session[:user_id]).to be_nil
      expect(current_user).to be_nil
    end
  end

  describe '#store_location' do
    it 'stores the forwarding URL in the session for a GET request' do
      helper.store_location
      expect(helper.session[:forwarding_url]).to eq('http://test.host')
    end
  end

  describe '#redirect_back_or' do
    it 'redirects to the stored location' do
      helper.session[:forwarding_url] = 'http://test.com/previous'
      expect(helper).to receive(:redirect_to).with('http://test.com/previous')
      helper.redirect_back_or('/default')
    end

    it 'redirects to the default location when no forwarding URL is stored' do
      expect(helper).to receive(:redirect_to).with('/default')
      helper.redirect_back_or('/default')
    end
  end
end
