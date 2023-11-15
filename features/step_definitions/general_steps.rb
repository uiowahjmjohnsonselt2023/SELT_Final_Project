
Given(/^I am logged in as "(.*)"$/) do |username|
  @user = User.create!(
    username: username,
    password: 'password',
    password_confirmation: 'password',
    email: username+'@test.com',
    phone_number: '1234567890'
  )
  visit login_path
  fill_in 'session[username]', with: @user.username
  fill_in 'session[password]', with: @user.password
  click_button 'Login'
end

Given(/^I am on the "(.*)" page$/) do |page_name|
  path = case page_name.downcase
         when 'home' then root_path
         when 'login' then login_path
         when 'signup' then signup_path
         when 'profile' then profile_path
         when 'sell item' then sell_path
         when 'search' then search_path("")
         # Add more pages here as needed
         else
           raise "No path defined for #{page_name}"
         end

  visit path
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
