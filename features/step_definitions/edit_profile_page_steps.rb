
Given(/^I am on the edit profile page$/) do
  visit edit_user_path(@user)
end

Given(/^I have added one payment method to my profile$/) do
  @user.payment_methods.create!(
    card_number: "**** **** **** 1234",
    expiration_date: 3.years.from_now
  )
end






