require 'spec_helper'
require 'rails_helper'

describe SessionsHelper, type: :helper do
  let(:user) { instance_double(User, session_token: 'token') }

  describe '#current_user' do
    before do
      allow(User).to receive(:find_by_session_token).with('token').and_return(user)
    end

    it 'returns nil when the user is not logged in' do
      expect(current_user).to be_nil
    end

    it 'sets and returns @current_user when logged in' do
      session[:session_token] = user.session_token
      expect(current_user).to eq(user)
    end
  end

  describe '#logged_in?' do
    it 'returns true when the user is logged in' do
      session[:session_token] = user.session_token
      allow(User).to receive(:find_by_session_token).with('token').and_return(user)
      expect(logged_in?).to be true
    end

    it 'returns false when the user is not logged in' do
      allow(helper).to receive(:current_user).and_return(nil)
      expect(logged_in?).to be false
    end
  end

  describe '#log_out' do
    it 'sets session_token and @current_user to nil' do
      session[:session_token] = 'token'
      log_out
      expect(session[:session_token]).to be_nil
      expect(current_user).to be_nil
    end
  end
end
