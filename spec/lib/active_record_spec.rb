# frozen_string_literal: true

require "spec_helper"
require "models/account"
require "models/user"
require "models/post"

describe AutoIncrement do
  before :all do
    @account1 = Account.create name: "My Account"
    @account2 = Account.create name: "Another Account", code: 50

    @user1_account1 = @account1.users.create name: "Felipe", letter_code: "Z"
    @user1_account2 = @account2.users.create name: "Daniel"
    @user2_account2 = @account2.users.create name: "Mark"
    @user3_account2 = @account2.users.create name: "Robert"
  end

  after :all do
    Account.delete_all
    User.delete_all
  end

  describe "initial" do
    it { expect(@account1.code).to eq 1 }
    it { expect(@user1_account1.letter_code).to eq "A" }
  end

  describe "do not increment outside scope" do
    it { expect(@user1_account2.letter_code).to eq "A" }
  end

  describe "not set column if is already set" do
    it { expect(@account2.code).to eq 50 }
  end

  describe "set column if option force is used" do
    it { expect(@user1_account1.letter_code).to eq "A" }
  end

  describe "locks query for increment" do
    before :all do
      threads = []
      lock = Mutex.new
      @account = Account.create name: "Another Account", code: 50
      @accounts = []
      5.times do |_t|
        threads << Thread.new do
          lock.synchronize do
            5.times do |_thr|
              @accounts << (@account.users.create name: "Daniel")
            end
          end
        end
      end
      threads.each(&:join)
    end

    let(:account_last_letter_code) do
      @accounts.max_by(&:letter_code).letter_code
    end

    it { expect(@accounts.size).to eq 25 }
    it { expect(account_last_letter_code).to eq "Y" }
  end

  describe "set before validation" do
    account3 = Account.new
    account3.valid?

    it { expect(account3.code).not_to be_nil }
  end

  describe "uses model scopes" do
    it { expect(@user3_account2.letter_code).to eq("C") }
  end

  describe "string column with integer initial" do
    it "increments correctly past the 9-to-10 boundary" do
      15.times do |i|
        post = Post.create!
        expect(post.ref.to_i).to eq(i + 1)
      end
    end
  end

  describe "deprecation warning" do
    it "warns when initial is a string on an integer column" do
      expect {
        Class.new(ActiveRecord::Base) do
          self.table_name = "accounts"
          auto_increment :code, initial: "A"
        end
      }.to output(/\[DEPRECATION\] The initial value type \(String\) does not match the column type \(integer\) for column 'code'.*raise an error in the future/).to_stderr
    end

    it "warns when initial is an integer on a string column" do
      expect {
        Class.new(ActiveRecord::Base) do
          self.table_name = "posts"
          auto_increment :ref, initial: 1
        end
      }.to output(/\[DEPRECATION\] The initial value type \(Integer\) does not match the column type \(string\) for column 'ref'.*raise an error in the future/).to_stderr
    end

    it "does not warn when types match (integer column, integer initial)" do
      expect {
        Class.new(ActiveRecord::Base) do
          self.table_name = "accounts"
          auto_increment :code, initial: 100
        end
      }.not_to output(/\[DEPRECATION\]/).to_stderr
    end

    it "does not warn when types match (string column, string initial)" do
      expect {
        Class.new(ActiveRecord::Base) do
          self.table_name = "posts"
          auto_increment :ref, initial: "X"
        end
      }.not_to output(/\[DEPRECATION\]/).to_stderr
    end
  end
end
