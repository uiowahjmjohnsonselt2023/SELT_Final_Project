Given(/^I search for my items/) do
  # Ensure that the bookmark button is on the page
  # visit the search page and search by seller
  visit search_path
  fill_in 'Seller', with: @user.username
  click_button 'filter'
end
