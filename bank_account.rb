require 'csv'
require 'time'


module Bank

  class Account
    attr_reader :balance, :id, :low_fund_warning
    attr_accessor :fee

    def initialize(id,balance,open_date)
      @min_balance = 0
      @id = id
      if under_min?(balance)
        raise ArgumentError.new(warning)
      end
      @balance = balance
      @open_date = open_date
      @fee = 0
    end

    def withdraw(amount,fee = @fee, min = @min_balance)
      if under_min?(balance - (amount + fee), min)
        puts warning(min)
        return @balance
      else
        return @balance = charge_fee(fee) - amount
      end
    end

    def deposit(amount)
      @balance += amount
    end

    def charge_fee(fee)
      return @balance - (fee)
    end

    def warning(min = @min_balance)
        puts "Insufficient fund warning: Balance cannot be less than $#{min}"
    end

    def add_owner(owner)
      @owner = owner
    end

    def under_min?(amount, min = @min_balance)
      amount < min
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

    # def self.money_to_dollars(cents)
    #   return "$#{cents.to_f/100.00}"
    # end

  end

class SavingsAccount < Account

  attr_reader :id, :balance, :open_date, :low_fund_warning
  attr_accessor :fee

  def initialize(id,balance,open_date)
    super
    @fee = 200
    @min_balance = 1000
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
    @fee = 100
  end

  def withdraw_using_check(amount)
    @check_fee = 200
    @min = -1000
    if @check_count <= 3
      @check_count += 1
      withdraw(amount,0,@min)
    else
      @check_count +=1
      withdraw(amount,@check_fee,@min)
    end
  end


  def reset_checks
    @check_count = 0
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
