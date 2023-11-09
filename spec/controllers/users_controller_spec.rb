require 'spec_helper'
require 'rails_helper'
if RUBY_VERSION>='2.6.0'
  if Rails.version < '5'
    class ActionController::TestResponse < ActionDispatch::TestResponse
      def recycle!
        # hack to avoid MonitorMixin double-initialize error:
        @mon_mutex_owner_object_id = nil
        @mon_mutex = nil
        initialize
      end
    end
  else
    puts "Monkeypatch for ActionController::TestResponse no longer needed"
  end
end

describe UsersController do
  describe 'showing a user' do
    it 'should call the model method that finds the user' do
      user = FactoryBot.create(:user) # Assuming you have a users factory
      expect(User).to receive(:find).with(user.id.to_s).and_return(user)
      get :show, params: { id: user.id }
    end

    it 'should render the show template' do
      user = FactoryBot.create(:user) # Create a user with FactoryBot
      allow(User).to receive(:find).and_return(user) # Stub the User.find call
      get :show, params: { id: user.id }
      expect(response).to render_template('show')
    end
  end
end



