Then(/^I should see the following items$/) do |table|
  table.hashes.each do |item|
    expect(page).to have_content(item['category'])
    expect(page).to have_content(item['title'])
    expect(page).to have_content(item['price'])
  end
end
