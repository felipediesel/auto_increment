# frozen_string_literal: true

require "spec_helper"
require "models/account"
require "models/user"
require "models/post"

describe AutoIncrement::Incrementor do
  def create_account(code:, name: "seed")
    Account.create!(name: name, code: code)
  end

  # Raw SQL is required because User has `force: true` — the auto_increment
  # callback would otherwise overwrite the value on `create!`.
  def create_user(code:, name: "seed")
    conn = ActiveRecord::Base.connection
    conn.execute "INSERT INTO users (name, letter_code) VALUES (#{conn.quote(name)}, #{conn.quote(code)})"
  end

  describe "#run" do
    describe "integer column" do
      it "auto-detects initial value 1 when no initial is given" do
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

    describe "string column" do
      it "sets initial value when no records exist" do
        user = User.new
        AutoIncrement::Incrementor.new(user, column: :letter_code, initial: "A").run
        expect(user.letter_code).to eq "A"
      end

      it "auto-detects initial value '1' when no initial is given" do
        post = Post.new
        AutoIncrement::Incrementor.new(post, column: :ref).run
        expect(post.ref).to eq "1"
      end

      {
        "A" => "B",
        "Z" => "AA",
        "AA" => "AB",
        "AAAAA" => "AAAAB"
      }.each do |previous_value, next_value|
        it "increments #{previous_value} to #{next_value}" do
          create_user(code: previous_value)

          user = User.new
          AutoIncrement::Incrementor.new(user, column: :letter_code, initial: "A").run
          expect(user.letter_code).to eq next_value
        end
      end

      it "uses length-aware ordering inferred from the column schema" do
        %w[1 2 3 4 5 6 7 8 9 10].each { |v| create_user(code: v) }

        user = User.new
        AutoIncrement::Incrementor.new(user, column: :letter_code, initial: 1).run
        expect(user.letter_code).to eq "11"
      end
    end

    describe "force" do
      it "does not overwrite an existing value when force is false" do
        account = Account.new(code: 5)
        expect { AutoIncrement::Incrementor.new(account).run }
          .not_to change { account.code }
      end

      it "overwrites an existing value when force is true" do
        create_account(code: 10)
        account = Account.new(code: 5)
        AutoIncrement::Incrementor.new(account, force: true).run
        expect(account.code).to eq 11
      end

      it "sets the initial value when force is true on an empty table" do
        account = Account.new(code: 5)
        AutoIncrement::Incrementor.new(account, force: true).run
        expect(account.code).to eq 1
      end
    end

    describe "scope" do
      it "only considers records within the same scope" do
        create_account(code: 10, name: "other")

        account = Account.new(name: "mine")
        AutoIncrement::Incrementor.new(account, scope: :name).run
        expect(account.code).to eq 1
      end
    end

    describe "model scope" do
      it "bypasses default_scope to see all records" do
        create_user(code: "C", name: "Mark")

        user = User.new
        AutoIncrement::Incrementor.new(user, column: :letter_code, initial: "A", model_scope: :with_mark).run
        expect(user.letter_code).to eq "D"
      end

      it "applies model scopes when building the query" do
        create_user(code: "C", name: "Mark")
        create_user(code: "A", name: "Other")

        user = User.new(name: "Mark")
        AutoIncrement::Incrementor.new(user, column: :letter_code, initial: "A", model_scope: :with_mark).run
        expect(user.letter_code).to eq "D"
      end

      it "only considers records matching the model scope" do
        create_account(code: 10, name: "Mark")
        create_account(code: 5, name: "Other")
        account = Account.new(name: "Mark")
        AutoIncrement::Incrementor.new(account, column: :code, initial: 1, model_scope: :only_mark).run
        expect(account.code).to eq 11
      end
    end

    describe "lock" do
      it "increments correctly with lock enabled" do
        create_account(code: 10)
        account = Account.new
        incrementor = AutoIncrement::Incrementor.new(account, lock: true)

        expect(incrementor.send(:maximum_query).lock_value).to eq true

        incrementor.run
        expect(account.code).to eq 11
      end
    end
  end
end
