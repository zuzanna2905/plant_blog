require 'test_helper'

class CreateCategoriesTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create(username: 'elo', email: 'elo@gmail.com',
                        password: 'elo', admin: true)
  end

  test 'get new category form and create category' do
    sign_in_as(@user, 'elo')
    get new_category_path
    assert_template 'categories/new'
    assert_difference 'Category.count', 1 do
      post categories_path, params: { category: { name: 'balcony' } }
      follow_redirect!
    end
    assert_template 'categories/index'
    assert_match 'balcony', response.body
  end

  test 'invalid category submission results in failure' do
    sign_in_as(@user, 'elo')
    get new_category_path
    assert_template 'categories/new'
    assert_no_difference 'Category.count' do
      post categories_path, params: { category: { name: ' ' } }
    end
    assert_template 'categories/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
end
