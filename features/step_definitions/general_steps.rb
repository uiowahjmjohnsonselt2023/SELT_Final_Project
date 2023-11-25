
Given(/^I am logged in as "(.*)"$/) do |username|

  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
    {
      :provider => "google_oauth2",
      :uid => "123456789",
      :info => {
        :name => username,
        :email => username + "@test.com"
      },
      :credentials => {
        :token => "token",
        :refresh_token => "refresh token"
      }
    }
  )
  # Visit the OmniAuth callback path
  visit '/auth/google_oauth2/callback'

  @user = User.find_by(username: username)
end


Given(/^I am on the "(.*)" page$/) do |page_name|
  path = case page_name.downcase
         when 'home' then root_path
         when 'login' then login_path
         when 'signup' then signup_path
         when 'profile' then user_path(@user.id) # Assign the profile path to the variable
         when 'sell item' then sell_path
         when 'search' then search_path
         # Add more pages here as needed
         else
           raise "No path defined for #{page_name}"
         end

  visit path
  # Expect the page to have content
  #expect(page).to have_content("f;dsghdasjk")
end

Then(/^I should be redirected to the "(.*)" page$/) do |page_name|
  path = case page_name.downcase
         when 'home' then root_path
         when 'login' then login_path
         when 'signup' then signup_path
         when 'profile' then profile_path
         when 'sell item' then sell_path
         when 'search' then search_path
         # Add more pages here as needed
         else
           raise "No path defined for #{page_name}"
         end

  expect(current_path).to eq(path)
end

When(/^I click on the "(.*)" link$/) do |link_name|
  # Click the link with the given link name
  click_link_or_button link_name
end
