require 'test_helper'
require 'capybara'
require 'capybara/dsl'
require 'database_cleaner'

Capybara.app = Agility::Application
Capybara.default_driver = :rack_test
DatabaseCleaner.strategy = :truncation

class CreateAccountTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  self.use_transactional_fixtures = false

  setup do
    DatabaseCleaner.start
  end

  teardown do
    DatabaseCleaner.clean
  end

  test "create account" do
    Capybara.current_driver = :selenium
    visit root_path
    click_link "Signup"
    fill_in "user_name", :with => "Test User"
    fill_in "user_email_address", :with => "test@example.com"
    fill_in "user_password", :with => "test123"
    fill_in "user_password_confirmation", :with => "test123"
    click_button "Signup"
    assert has_content?("Thanks for signing up!")
  end
end
