# encoding: utf-8

require File.expand_path(File.join(File.dirname(__FILE__), 'test_helper'))

class AutoIncrementActiveRecordTest < ActiveRecord::TestCase
  def setup
    @account1 = Account.create :name => 'My Account'
    @account2 = Account.create :name => 'My Second Account'
    @user1 = @account1.users.create :name => 'Felipe'
    @user2 = @account1.users.create :name => 'Sabrina'

    @user_account2 = @account2.users.create :name => 'Daniel'

    @user3 = @account1.users.create :name => 'Paulo'
    @user3.letter_code = 'Z'
    @user3.save

    @user4 = @account1.users.create :name => 'Marlene'
    @user4.save

    @user5 = @account1.users.create :name => 'Patricia'
    @user5.save

  end

  test "use initial" do
    assert_equal 1, @account1.code

    assert_equal 'A', @user1.letter_code
  end

  test "increments numbers" do
    assert_equal 2, @account2.code
  end

  test "increments letters" do
    assert_equal 'B', @user2.letter_code
  end

  test "do not increment outside scope" do
    assert_equal 'A', @user_account2.letter_code
  end

  test "checks if Z increments to AA" do
    assert_equal 'AA', @user4.letter_code
  end

  test "checks if AA increments to AB" do
    assert_equal 'AB', @user5.letter_code
  end

end
