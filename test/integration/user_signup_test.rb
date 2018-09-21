require "test_helper"

class UserSignupTest < ActionDispatch::IntegrationTest
  
  test "get signup form and sign up new user" do
    get signup_path
    assert_template "users/new"
    assert_difference "User.count", 1 do
      post_via_redirect users_path, user: {username: "Bob", email: "bob@bobmail.com", password: "password", admin: false}
    end
    assert_template "users/show"
    assert_match "Bob", response.body
  end
  
  test "invalid account details result in failure and account not created" do
    assert_no_difference "User.count" do
      post users_path, user: {username: " ", email: "bob@bobmail.com", password: "password", admin: false}
    end
    assert_template "users/new"
  end

  
end