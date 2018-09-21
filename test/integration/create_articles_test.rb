require "test_helper"

class CreateArticlesTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create(username: "Bob", email: "bob@bobmail.com", password: "password", admin: false)
  end
  
  test "create article successfully" do
    sign_in_as(@user, "password")
    get new_article_path
    assert_template "articles/new"
    assert_difference "Article.count", 1 do
      post_via_redirect articles_path, article: {title: "Article *Testing* Title", description: "Test article description", user_id: @user.id}
    end
    assert_template "articles/show"
    assert_match "Article *Testing* Title", response.body
  end

  test "invalid article submission leads to failure" do
    sign_in_as(@user, "password")
    get new_article_path
    assert_template "articles/new"
    assert_no_difference "Article.count" do
      post_via_redirect articles_path, article: {title: "Article *Testing* Title", description: " ", user_id: @user.id}
    end
    assert_template "articles/new"

  end
  
end