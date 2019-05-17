require 'test_helper'

class CreateUsersTest < ActionDispatch::IntegrationTest

  test 'get new user form and create user' do
    get signup_path
    assert_template 'users/new'
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { username: 'elo', email: 'elo@gmail.com',
                                         password: 'elo' } }
      follow_redirect!
    end
    assert_template 'users/show'
    assert_match 'elo', response.body
  end

  test 'invalid user submission [worng email] results in failure' do
    get signup_path
    assert_template 'users/new'
    assert_no_difference 'User.count' do
      post users_path, params: { user: { username: 'elo',
                                         email: 'elo',
                                         password: 'elo' } }
    end
    assert_template 'users/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
end
