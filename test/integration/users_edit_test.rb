require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:scarlet)
  end

  test 'unsuccessful edit' do
    log_in_as @user
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), :params => { :user => { :name => '',
                                                   :email => '422342@s', 
                                                :password => 'hello',
                                   :password_confirmation => 'goodbye' } }
    assert_template 'users/edit'
    assert_select 'div.alert', /contains 4 errors/
  end

  test 'successful edit with friendly forwarding' do
    get edit_user_path(@user)
    log_in_as @user
    assert_redirected_to edit_user_path(@user)
    assert_nil session[:forwarding_url]
    name = "Ozymandias Speakman"
    email = "ozymandias@gmail.com"
    patch user_path(@user), :params => { :user => { :name => name,
                                                   :email => email,
                                                :password => '',
                                   :password_confirmation => '' } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
end
