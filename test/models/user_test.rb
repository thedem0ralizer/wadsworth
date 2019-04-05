require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: 'john doe', email: 'john@doe.net', password: 'foobar123',
                                                              password_confirmation: 'foobar123')
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'name should be present' do
    @user.name = " "
    assert_not @user.valid?
  end

  test 'email should be present' do
    @user.email = ' '
    assert_not @user.valid?
  end

  test 'name not too long' do
    @user.name = 'a' * 51
    assert_not @user.valid?
  end

  test 'email not too long' do
    @user.email = 'a' * 256
    assert_not @user.valid?
  end

  test 'email validation should accept valid emails' do
    valid_addresses = %w[ben@flameboss.com benjamin@flameboss.co.uk USER@flame.boss.org
                          ozy.mandias@dog.jp max+mochi@cat.cn]
    valid_addresses.each do |address|
      @user.email = address
      assert @user.valid?, "#{address.inspect} should be valid"
    end
  end

  test 'email validation should reject invalid emails' do
    invalid_addresses = %w[ben@flameboss,com benjamin_at_flameboss.co.uk USER.NAME@flame.boss.
                            ozy@man_dias.net ozy@man+dias.gov ben@flameboss..com]
    invalid_addresses.each do |address|
      @user.email = address
      assert_not @user.valid?, "#{address.inspect} should be invalid"
    end
  end

  test 'email addresses should be unique' do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test 'emails are saved as lowercase' do
    mixed_case_email = 'sPoNgEbOb.SqUaRePaNtS@bikini.bottom'
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test 'password should not be blank' do
    @user.password = ' ' * 8
    @user.password_confirmation = ' ' * 8
    @user.save
    assert_not @user.valid?
  end

  test 'password is not too short' do
    @user.password = @user.password_confirmation = 'abc1234'
    @user.save
    assert_not @user.valid?
  end

end
