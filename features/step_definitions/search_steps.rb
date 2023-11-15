Then(/^I should see the following items$/) do |table|
  table.hashes.each do |item|
    expect(page).to have_content(item['category'])
    expect(page).to have_content(item['title'])
    expect(page).to have_content(item['price'])
  end
end

Then(/^I should see the correct filters$/) do
  # expect the correct filters to be present
  expect(page).to have_content('Filter by categories')
  expect(page).to have_content('Filter by price')
  expect(page).to have_content('My Bookmarks Only')
end

When(/^I check the "(.*?)" category filter$/) do |category_name|
  # Ensure all checkboxes are initially unchecked
  all('.category_checkbox input[type=checkbox]').each do |checkbox|
    checkbox.set(false)
  end

  # Now check the specified category
  check("categories_#{category_name.parameterize}")

end

And(/^I check the my bookmarks only filter$/) do
  check('bookmarks')
end

And(/^I fill in "([^"]*)" with "([^"]*)"$/) do |arg1, arg2|
  fill_in(arg1, with: arg2)
end
