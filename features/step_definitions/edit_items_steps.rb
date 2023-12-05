Given(/^I search for my items/) do
  # Ensure that the bookmark button is on the page
  # visit the search page and search by seller
  visit search_path
  fill_in 'Seller', with: @user.username
  click_button 'Filter'
end

And(/^I edit the item as the following:$/) do |table|
  # table is a table.hashes.keys # => [:title, :description, :categories, :price]
  items = table.hashes
  items.each do |item|
    # Find the item with the given title
    item = Item.find_by(title: item[:title])
    # Edit the item
    visit edit_item_path(item)
    fill_in 'Title', with: item[:title]
    fill_in 'Description', with: item[:description]
    fill_in 'Price', with: item[:price]
    click_button 'Update Item'
  end
end

Then(/^I should see the item page for the following item:$/) do |table|
  # table is a table.hashes.keys # => [:title, :description, :categories, :price]
  items = table.hashes
  items.each do |item|
    # Find the item with the given title
    item = Item.find_by(title: item[:title])
    # Ensure that the page has the item's title
    expect(page).to have_content(item.title)
    # Ensure that the page has the item's description
    expect(page).to have_content(item.description)
    # Ensure that the page has the item's categories
    expect(page).to have_content(item.categories)
    # Ensure that the page has the item's price
    expect(page).to have_content(item.price)
  end
end

Then(/^I should see the item page for "([^"]*)"$/) do |arg|
    # Find the item with the given title
    item = @user.items.find_by(title: arg)
    # Ensure that the page has the item's title
    expect(page).to have_content(item.title)
    # Ensure that the page has the item's description
    expect(page).to have_content(item.description)
    # Ensure that the page has the item's categories
    expect(page).to have_content(item.categories.map(&:name).join(', '))
    # Ensure that the page has the item's price
    expect(page).to have_content(item.price)
end
