require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test 'bad signups do not create new user and show error messages' do
    get signup_path
    assert_no_difference 'User.count' do
      assert_select 'form[action="/signup"]'
      post signup_path, params: { user: { name: '',
                                        email: 'bad@email',
                                     password: 'too',
                        password_confirmation: 'short' } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test 'good signups create new user and show success message' do
    get signup_path
    assert_difference 'User.count', 1 do
      post signup_path, params: { user: { name: 'rails user',
                                        email: 'example@railstutorial.org',
                                     password: 'odin1025',
                        password_confirmation: 'odin1025' } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_select 'div.alert-success'
  end
end
