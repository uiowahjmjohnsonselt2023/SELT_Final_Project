Given('I am on the home page') do
  visit root_path
end

When('I navigate to the Item Page') do
  # Assuming there's a link to the item page, perhaps with an id or text
  click_on 'Item Page Link Text'
end

Then('I should see the Item Title') do
  # Verify that the item title is present on the page
  expect(page).to have_css('h1.item-title')
end
