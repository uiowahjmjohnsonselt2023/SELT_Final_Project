require 'omniauth'

RSpec.configure do |config|

  # config.include SessionsHelper, type: :controller
  # rspec-expectations config goes here. You can use an alternate
  # assertion/expectation library such as wrong or the stdlib/minitest
  # assertions if you prefer.
  config.expect_with :rspec do |expectations|
    # This option will default to `true` in RSpec 4. It makes the `description`
    # and `failure_message` of custom matchers include text for helper methods
    # defined using `chain`, e.g.:
    #     be_bigger_than(2).and_smaller_than(4).description
    #     # => "be bigger than 2 and smaller than 4"
    # ...rather than:
    #     # => "be bigger than 2"
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    # mocks.verify_partial_doubles = true
    mocks.verify_partial_doubles = false
  end
  config.filter_run_excluding pending: true

  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
    {
      :provider => "google_oauth2",
      :uid => "123456789",
      :info => {
        :name => "Tony Stark",
        :email => "tony@stark.com"
      },
      :credentials => {
        :token => "token",
        :refresh_token => "refresh token"
      }
    }
  )

  # The settings below are suggested to provide a good initial experience
  # with RSpec, but feel free to customize to your heart's content.
=begin
  # These two settings work together to allow you to limit a spec run
  # to individual examples or groups you care about by tagging them with
  # `:focus` metadata. When nothing is tagged with `:focus`, all examples
  # get run.
  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  # Allows RSpec to persist some state between runs in order to support
  # the `--only-failures` and `--next-failure` CLI options. We recommend
  # you configure your source control system to ignore this file.
  config.example_status_persistence_file_path = "spec/examples.txt"

  # Limits the available syntax to the non-monkey patched syntax that is
  # recommended. For more details, see:
  #   - http://myronmars.to/n/dev-blog/2012/06/rspecs-new-expectation-syntax
  #   - http://www.teaisaweso.me/blog/2013/05/27/rspecs-new-message-expectation-syntax/
  #   - http://myronmars.to/n/dev-blog/2014/05/notable-changes-in-rspec-3#new__config_option_to_disable_rspeccore_monkey_patching
  config.disable_monkey_patching!

  # Many RSpec users commonly either run the entire suite or an individual
  # file, and it's useful to allow more verbose output when running an
  # individual spec file.
  if config.files_to_run.one?
    # Use the documentation formatter for detailed output,
    # unless a formatter has already been configured
    # (e.g. via a command-line flag).
    config.default_formatter = 'doc'
  end

  # Print the 10 slowest examples and example groups at the
  # end of the spec run, to help surface which specs are running
  # particularly slow.
  config.profile_examples = 10

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = :random

  # Seed global randomization in this process using the `--seed` CLI option.
  # Setting this allows you to use `--seed` to deterministically reproduce
  # test failures related to randomization by passing the same `--seed` value
  # as the one that triggered the failure.
  Kernel.srand config.seed
=end
end

def database_setup
  User.delete_all
  Item.delete_all
  Address.delete_all
  PaymentMethod.delete_all
  Image.delete_all
  Category.delete_all

  image_file_path = Rails.root.join('spec', 'support', 'fixtures', 'test_image.png')
  image_type, image_data = Image.get_image_data(image_file_path)

  categories = ["Category 1", "Category 2", "Category 3", "Category 4", "Category 5"].map do |category_name|
    Category.create!(name: category_name)
  end

  # Create a main sample user.
  main_user = User.create!(
    username: "mainuser",
    email: "mainuser@example.com",
    phone_number: "1234567890"
  )
  main_user.addresses.create!(
    shipping_address_1: "mainuser_address_1_1",
    shipping_address_2: "mainuser_address_1_2",
    city: "mainuser_city_1",
    state: "mainuser_state_1",
    country: "mainuser_country_1",
    postal_code: "12345"
  )
  main_user.addresses.create!(
    shipping_address_1: "mainuser_address_2_1",
    shipping_address_2: "mainuser_address_2_2",
    city: "mainuser_city_2",
    state: "mainuser_state_2",
    country: "mainuser_country_2",
    postal_code: "67890"
  )
  main_user.payment_methods.create!(
    encrypted_card_number: "mainuser_card_number",
    encrypted_card_number_iv: "mainuser_card_number_iv",
    expiration_date: Date.new(2000, 01, 01).to_s(:long)
  )

  5.times do |n|
    item = main_user.items.create!(
      title: "mainuser_item#{n + 1}_title",
      description: "mainuser_item#{n + 1}_description",
      price: n + 1 + 10
    )
    item.images.create!(data: image_data, image_type: image_type)
    item.categories << categories[n]
  end

  5.times do |n|
    username = "user#{n + 1}"
    user = User.create!(
      username: username,
      email: "#{username}@example.com",
      phone_number: "123456789#{n}"
    )
    user.addresses.create!(
      shipping_address_1: "#{username}_address_1",
      shipping_address_2: "#{username}_address_2",
      city: "#{username}_city",
      state: "#{username}_state",
      country: "#{username}_country",
      postal_code: "0000#{n + 1}"
    )
    user.payment_methods.create!(
      encrypted_card_number: "#{username}_card_number",
      encrypted_card_number_iv: "#{username}_card_number_iv",
      expiration_date: Date.new(2000, 01, 01).to_s(:long)
    )
    item = user.items.create!(
      title: "#{username}_item_title",
      description: "#{username}_item_description",
      price: n + 1
    )
    item.images.create!(data: image_data, image_type: image_type)
    item.categories << categories[n]
  end
end
