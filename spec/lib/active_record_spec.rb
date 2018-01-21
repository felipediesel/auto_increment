require 'spec_helper'
require 'models/account'
require 'models/user'

describe AutoIncrement do
  before :all do
    @account1 = Account.create name: 'My Account'
    @account2 = Account.create name: 'Another Account', code: 50

    @user1_account1 = @account1.users.create name: 'Felipe', letter_code: 'Z'
    @user1_account2 = @account2.users.create name: 'Daniel'
    @user2_account2 = @account2.users.create name: 'Mark'
    @user3_account2 = @account2.users.create name: 'Robert'
  end

  describe 'initial' do
    it { expect(@account1.code).to eq 1 }
    it { expect(@user1_account1.letter_code).to eq 'A' }
  end

  describe 'do not increment outside scope' do
    it { expect(@user1_account2.letter_code).to eq 'A' }
  end

  describe 'not set column if is already set' do
    it { expect(@account2.code).to eq 50 }
  end

  describe 'set column if option force is used' do
    it { expect(@user1_account1.letter_code).to eq 'A' }
  end

  describe 'locks query for increment' do
    before :all do
      threads = []
      lock = Mutex.new
      @account = Account.create name: 'Another Account', code: 50
      @accounts = []
      5.times do |_t|
        threads << Thread.new do
          lock.synchronize do
            5.times do |_thr|
              @accounts << (@account.users.create name: 'Daniel')
            end
          end
        end
      end
      threads.each(&:join)
    end

    let(:account_last_letter_code) do
      @accounts.sort_by(&:letter_code).last.letter_code
    end

    it { expect(@accounts.size).to eq 25 }
    it { expect(account_last_letter_code).to eq 'Y' }
  end

  describe 'set before validation' do
    account3 = Account.new
    account3.valid?

    it { expect(account3.code).not_to be_nil }
  end

  describe 'uses model scopes' do
    it { expect(@user3_account2.letter_code).to eq('C') }
  end
end
