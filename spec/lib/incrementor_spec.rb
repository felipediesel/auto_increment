require 'spec_helper'

describe AutoIncrement::Incrementor do
  {
    nil => 1,
    0 => 1,
    1 => 2,
    'A' => 'B',
    'Z' => 'AA',
    'AA' => 'AB',
    'AAAAA' => 'AAAAB'
  }.each do |previous_value, next_value|
    describe "increment value for #{previous_value}" do
      it do
        allow(subject).to receive(:maximum) { previous_value }
        expect(subject.send(:increment)).to eq next_value
      end
    end
  end

  describe 'initial value of string' do
    subject do
      AutoIncrement::Incrementor.new initial: 'A'
    end

    it do
      allow(subject).to receive(:maximum) { nil }
      expect(subject.send(:increment)).to eq 'A'
    end
  end
end
