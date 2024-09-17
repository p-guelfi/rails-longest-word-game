require "application_system_test_case"

class GamesTest < ApplicationSystemTestCase
  test "Going to /new gives us a new random grid to play with" do
    visit "/new"
    assert test: "New game"
    assert_selector ".letter-box", count: 10
  end
end
