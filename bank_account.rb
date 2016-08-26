#utilize charge_fee method
#Change to cents
require 'csv'
require 'time'

module Bank

  class Account
    attr_reader :balance, :id, :low_fund_warning
    attr_accessor :fee

    def initialize(id,balance,open_date)
      @min_balance = 0
      @low_fund_warning = "Insufficient fund warning: Balance cannot be less than $#{@min_balance}"
      @id = id
      if under_min?(balance)
        raise ArgumentError.new(@low_fund_warning)
      end
      @balance = balance
      @open_date = open_date
      @fee = 0
    end

    def withdraw(amount)
      if under_min?(balance - (amount + @fee))
        puts @low_fund_warning
      else
        @balance = charge_fee(@fee) - amount
      end
    end

    def deposit(amount)
      @balance += amount
    end

    def charge_fee(fee)
      return @balance - (fee)
    end


    def add_owner(owner)
      @owner = owner
    end

    def under_min?(amount)
      amount < @min_balance
    end

    def self.all
      @all = []
      CSV.open('testcsv.csv','r').each do |line|
        id = line[0].to_i
        balance = line[1].to_i
        open_date = Time.parse(line[2])
        @all << self.new(id,balance,open_date)
      end
      return @all
    end

    def to_s
    "Account ID: #{@id}, Balance: #{@balance}, Open Date: #{@open_date}"
    end

    def self.find(id)
      @all.each do |x|
        if id == x.id
          return x
        end
      end
    end

end

class SavingsAccount < Account

  attr_reader :id, :balance, :open_date, :low_fund_warning
  attr_accessor :fee

  def initialize(id,balance,open_date)
    @min_balance = 1000
    super
    if under_min?(balance)
      raise ArgumentError.new(low_fund_warning)
    end
    @fee = 200
  end

  def add_interest(rate)
    interest_earned = balance * rate/10000
  end
end

class CheckingAccount < Account

  attr_accessor :check_count

  def initialize(id,balance,open_date)
    super
    @check_count = 0
  end

  def withdraw(amount)
    fee = 100
    if under_min?(balance - (amount + fee))
      puts @low_fund_warning
    else
      @balance = charge_fee(fee) - amount
    end

  end

  def withdraw_using_check(amount)
    check_fee = 200
    if @balance - (check_fee + amount) > -1000
      if @check_count <= 3
         @check_count += 1
         return @balance - (amount + check_fee)
      else
        @check_count += 1
        return @balance -= (amount + check_fee)
      end
    else
      puts "Insufficient fund warning: Balance cannot be less than -$10."
    end
  end

  def reset_checks
    @check = 0
  end

end

  class Owner
    attr_accessor :name

    def initialize(name, address, zip)
      @name = name
      @address = address
      @zip = zip
    end

  end
end

#________Tests for Wave 1
account_info = CSV.read('support/accounts.csv')
id = account_info[0][0].to_i
balance = account_info[0][1].to_i
open_date = Time.parse(account_info[0][2])

# tst1 = Bank::Account.new(id,balance,open_date)
# puts tst1.withdraw(5)
# puts tst1.balance
# puts tst1.deposit(5)
# puts tst1.balance
# puts tst1.withdraw(5)

#_________Tests for Wave 2
# Bank::Account.all
# puts Bank::Account.find(1212)

#_________Tests for Wave 3
tst2 = Bank::SavingsAccount.new(id,balance,open_date)
puts tst2.balance
puts tst2.withdraw(10)
puts tst2.withdraw(10)
puts tst2.balance

tst3 = Bank::CheckingAccount.new(id,balance,open_date)

# puts tst3.withdraw_using_check(10)
# puts tst3.withdraw_using_check(100)
# puts tst3.withdraw_using_check(10)
# puts tst3.withdraw_using_check(10)
# puts tst3.withdraw_using_check(10)
# puts tst3.withdraw_using_check(10)
# puts tst3.withdraw_using_check(100000000000)



# tst3 = Bank::CheckingAccount.new(id,100,open_date)
# tst3.withdraw(200)
#
