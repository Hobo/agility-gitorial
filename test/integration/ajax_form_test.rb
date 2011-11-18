# -*- coding: utf-8 -*-
require 'test_helper'
require 'capybara'
require 'capybara/dsl'
require 'database_cleaner'

Capybara.app = Agility::Application
Capybara.default_driver = :rack_test
DatabaseCleaner.strategy = :truncation

class AjaxFormTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Factory::Syntax::Methods

  self.use_transactional_fixtures = false

  setup do
    DatabaseCleaner.start
    @admin = create(:admin)
    @project = create(:project)
    @s1 = create(:story, :project => @project)
    @s2 = create(:story, :project => @project, :title => "Sample Story 2")
  end

  teardown do
    DatabaseCleaner.clean
  end

  test "ajax forms" do
    Capybara.current_driver = :selenium
    Capybara.default_wait_time = 5
    visit root_path

    # log in as Administrator
    click_link "Login"
    fill_in "login", :with => "admin@example.com"
    fill_in "password", :with => "test123"
    click_button "Login"
    assert has_content?("Logged in as Admin User")

    # define statuses
    visit "/story_statuses/index2"

    # verify that qunit tests have passed.
    assert has_content?("0 failed.")

    find("#form1").fill_in("story_status_name", :with => "foo")
    find("#form1").click_button("new")
    assert_equal "foo", find("ul.statuses li:first .story-status-name").text

    find("#form2").fill_in("story_status_name", :with => "foo2")
    find("#form2").click_button("new")
    assert_equal "foo2", find("ul.statuses li:nth-child(2) .story-status-name").text

    find("#form3").fill_in("story_status_name", :with => "foo3")
    find("#form3").click_button("new")
    assert_equal "foo3", find("ul.statuses li:nth-child(3) .story-status-name").text

    find("#form4").fill_in("story_status_name", :with => "foo4")
    find("#form4").click_button("new")
    assert_equal "foo4", find("ul.statuses li:nth-child(4) .story-status-name").text

    visit "/projects/#{@project.id}/show2"
    assert_not_equal "README", find(".report-file-name-view").text
    attach_file("project[report]", File.join(::Rails.root, "README"))
    click_button "upload new report"
    assert find(".report-file-name-view").has_content?("README")

    # these should be set by show2's custom-scripts
    assert find(".events").has_text?("events: rapid:ajax:before rapid:ajax:success rapid:ajax:complete")
    assert find(".callbacks").has_text?("callbacks: before success complete")

    find(".story.odd").fill_in("story_title", :with => "s1")
    find(".story.odd input.story-title").native.send_key(:return)
    assert find(".story.odd .view.story-title").has_content?("s1")
    assert find(".story.odd .ixz").has_content?("1")

    find(".story.even").fill_in("story_title", :with => "s2")
    find(".story.even input.story-title").native.send_key(:return)
    assert find(".story.even .view.story-title").has_content?("s2")
    assert find(".story.even .ixz").has_content?("2")
  end
end
