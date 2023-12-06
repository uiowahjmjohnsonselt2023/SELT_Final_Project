Then('I should see the Item Title') do
  # Verify that the item title is present on the page
  expect(page).to have_css('h1.item-title')
end

When(/^I click on the item link$/) do
  # Click on the link with the given button name
  click_link_or_button @user.items.first.title
end

# given I search for an item
Given(/^I search for "(.*)"$/) do |search_term|
  # make a search request
  visit search_path(search_term: search_term)
end

Then(/^I should see the item "(.*)"$/) do |item_title|
  # Verify that the item title is present on the page
  expect(page).to have_content(item_title)
end

Then(/^I should see the item page:$/) do |table|
  table.hashes.each do |item|
    expect(page).to have_content(item['user'])
    expect(page).to have_content(item['title'])
    expect(page).to have_content(item['description'])
    expect(page).to have_content(item['price'])
    expect(page).to have_content(item['length'])
    expect(page).to have_content(item['width'])
    expect(page).to have_content(item['height'])
    expect(page).to have_content(item['dimension_units'])
    expect(page).to have_content(item['weight'])
    expect(page).to have_content(item['weight_units'])
    expect(page).to have_content(item['condition'])
  end
end
