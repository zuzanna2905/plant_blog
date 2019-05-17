require 'test_helper'

class CreateArticlesTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create(username: 'elo', email: 'elo@gmail.com',
                        password: 'elo', admin: true)
  end

  test 'get new article form and create article' do
    sign_in_as(@user, 'elo')
    get new_article_path
    assert_template 'articles/new'
    assert_difference 'Article.count', 1 do
      post articles_path, params: { article: { title: 'Monstera',
                                               description:
                                               'My new babe plant. Love it!' } }
      follow_redirect!
    end
    assert_template 'articles/show'
    assert_match 'Monstera', response.body
    assert_match 'My new babe plant. Love it!', response.body
  end

  test 'invalid article submission results in failure' do
    sign_in_as(@user, 'elo')
    get new_article_path
    assert_template 'articles/new'
    assert_no_difference 'Article.count' do
      post articles_path, params: { article: { title: '',
                                               description:
                                               'My new babe plant. Love it!' } }
    end
    assert_template 'articles/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
end
