

Then('I should see the Item Title') do
  # Verify that the item title is present on the page
  expect(page).to have_css('h1.item-title')
end

Then(/^I should see the item page$/) do
  # Verify that the item title is present on the page
  user = User.find_by(username: 'testuser')
  expect(page).to have_content(user.items.first.title)
  expect(current_path).to eq(item_path(user.items.first))
end

When(/^I click on the item link$/) do
  # Click on the link with the given button name
  user = User.find_by(username: 'testuser')
  click_link_or_button user.items.first.title
end

# given I search for an item
Given(/^I search for "(.*)"$/) do |search_term|
  # make a search request
  visit search_path(query: search_term)
end

Then(/^I should see the item "(.*)"$/) do |item_title|
  # Verify that the item title is present on the page
  expect(page).to have_content(item_title)
end
