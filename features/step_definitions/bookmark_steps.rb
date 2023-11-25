Then(/^I should see the bookmark button$/) do
  # Ensure that the bookmark button is on the page
  expect(page).to have_content('Bookmark')
end

Given(/^I bookmark the "([^"]*)" item$/) do |arg|
  # Find the item with the given title
  item = Item.find_by(title: arg)

  # Bookmark the item
  @user.add_bookmark(item)
end

Then(/^I should see the "([^"]*)" item$/) do |arg|
  # Ensure that the item is on the page
  expect(page).to have_content(arg)
end

Then(/^I should not see the "([^"]*)" item$/) do |arg|
  # Ensure that the item is not on the page
  expect(page).to_not have_content(arg)
end

And(/^I unbookmark the "([^"]*)" item$/) do |arg|
  # Find the item with the given title
  # Expect the item page to not have
  item = Item.find_by(title: arg)

  # Unbookmark the item
  @user.remove_bookmark(item)
end
