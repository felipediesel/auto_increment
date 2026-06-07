# frozen_string_literal: true

require "spec_helper"
require "models/account"
require "models/user"

describe AutoIncrement::Incrementor do
  before do
    Account.delete_all
    User.delete_all
  end

  def create_account(code:, name: "seed")
    conn = ActiveRecord::Base.connection
    conn.execute "INSERT INTO accounts (name, code) VALUES (#{conn.quote(name)}, #{conn.quote(code)})"
  end

  def create_user(letter_code:, name: "seed")
    conn = ActiveRecord::Base.connection
    conn.execute "INSERT INTO users (name, letter_code) VALUES (#{conn.quote(name)}, #{conn.quote(letter_code)})"
  end

  describe "#run" do
    describe "integer" do
      it "increments nil to 1" do
        account = Account.new
        AutoIncrement::Incrementor.new(account).run
        expect(account.code).to eq 1
      end

      {
        0 => 1,
        1 => 2,
        9 => 10
      }.each do |previous_value, next_value|
        it "increments #{previous_value} to #{next_value}" do
          create_account(code: previous_value)

          account = Account.new
          AutoIncrement::Incrementor.new(account).run
          expect(account.code).to eq next_value
        end
      end
    end

    describe "string" do
      it "uses the initial value when no records exist" do
        user = User.new
        AutoIncrement::Incrementor.new(user, column: :letter_code, initial: "A").run
        expect(user.letter_code).to eq "A"
      end

      {
        "A" => "B",
        "Z" => "AA",
        "AA" => "AB",
        "AAAAA" => "AAAAB"
      }.each do |previous_value, next_value|
        it "increments #{previous_value} to #{next_value}" do
          create_user(letter_code: previous_value)

          user = User.new
          AutoIncrement::Incrementor.new(user, column: :letter_code, initial: "A").run
          expect(user.letter_code).to eq next_value
        end
      end
    end

    describe "when column value is already set" do
      it "does not change the column if force is false" do
        account = Account.new(code: 5)
        expect { AutoIncrement::Incrementor.new(account).run }
          .not_to change { account.code }
      end

      it "changes the column if force is true" do
        create_account(code: 10)
        account = Account.new(code: 5)
        AutoIncrement::Incrementor.new(account, force: true).run
        expect(account.code).to eq 11
      end
    end

    describe "scoped increment" do
      it "only considers records within the same scope" do
        create_account(code: 10, name: "other")

        account = Account.new(name: "mine")
        AutoIncrement::Incrementor.new(account, scope: :name).run
        expect(account.code).to eq 1
      end
    end
  end

  describe "locking the query" do
    it "increments correctly with lock enabled" do
      create_account(code: 10)
      account = Account.new
      AutoIncrement::Incrementor.new(account, lock: true).run
      expect(account.code).to eq 11
    end
  end
end
