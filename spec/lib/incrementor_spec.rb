# frozen_string_literal: true

require "spec_helper"
require "models/account"
require "models/user"

describe AutoIncrement::Incrementor do
  {
    nil => 1,
    0 => 1,
    1 => 2,
    "A" => "B",
    "Z" => "AA",
    "AA" => "AB",
    "AAAAA" => "AAAAB"
  }.each do |previous_value, next_value|
    describe "increment value for #{previous_value}" do
      subject do
        AutoIncrement::Incrementor.new User.new
      end

      it do
        allow(subject).to receive(:maximum) { previous_value }
        expect(subject.send(:increment)).to eq next_value
      end
    end
  end

  describe "initial value of string" do
    subject do
      AutoIncrement::Incrementor.new User.new, initial: "A"
    end

    it do
      allow(subject).to receive(:maximum) { nil }
      expect(subject.send(:increment)).to eq "A"
    end
  end

  describe "locking the query" do
    subject do
      AutoIncrement::Incrementor.new Account.new, :code, lock: true
    end

    it "returns a locked relation for the maximum query" do
      relation = subject.send(:maximum_query)

      expect(relation.lock_value).to eq(true)
    end
  end
end
