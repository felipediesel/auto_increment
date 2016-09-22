require 'spec_helper'
require 'models/account'
require 'models/user'
require 'models/sale'
require 'models/customer'

describe AutoIncrement do
  before :all do
    @account1 = Account.create name: 'My Account'
    @account2 = Account.create name: 'Another Account', code: 50

    @user_account1 = @account1.users.create name: 'Felipe', letter_code: 'Z'
    @user_account2 = @account2.users.create name: 'Daniel'

    @sale1 = @account1.sales.create status: :complete
    @sale2 = @account1.sales.create status: :canceled
    @sale3 = @account1.sales.create status: :canceled

    @customer1 = @account1.customers.create
    @customer2 = @account1.customers.create
    @customer3 = @account2.customers.create
  end

  describe 'initial' do
    it { expect(@account1.code).to eq 1 }
    it { expect(@user_account1.letter_code).to eq 'A' }
  end

  describe 'do not increment outside scope' do
    it { expect(@user_account2.letter_code).to eq 'A' }
  end

  describe 'not set column if is already set' do
    it { expect(@account2.code).to eq 50 }
  end

  describe 'set column if option force is used' do
    it { expect(@user_account1.letter_code).to eq 'A' }
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

  describe 'moment to increment' do
    context 'after creation' do
      it { expect(@sale1.sale_number).to eq(1)  }
      it { expect(@sale2.sale_number).to eq(1)  }
      it { expect(@sale3.sale_number).to eq(2)  }

      it { expect(@customer1.customer_number).to eq(1)  }
      it { expect(@customer2.customer_number).to eq(2)  }
      it { expect(@customer3.customer_number).to eq(1)  }
    end

    context 'after update' do
      context 'with force' do
        context 'when not setting auto increment field to blank' do
          before do
            @sale1.status = :canceled
            @sale1.save
          end

          it { expect(@sale1.sale_number).to eq(3)  }
        end

        context 'when setting auto increment field to blank' do
          before do
            @sale1.status = :canceled
            @sale1.sale_number = nil
            @sale1.save
          end

          it { expect(@sale1.sale_number).to eq(3)  }
        end
      end

      context 'without force' do
        context 'when not setting auto increment field to blank' do
          before do
            @customer1.account = @account2
            @customer1.save
          end

          it { expect(@customer1.customer_number).to eq(1)  }
        end

        context 'when setting auto increment field to blank' do
          before do
            @customer1.account = @account2
            @customer1.customer_number = nil
            @customer1.save
          end

          it { expect(@customer1.customer_number).to eq(2)  }
        end
      end
    end
  end
end
