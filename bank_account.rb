module Bank
  class Account

    attr_reader :balance
    attr_reader :owner

    def initialize(id,balance)
      @id = id
      if balance < 0
        raise ArgumentError.new("Initial Balance cannot be negative")
      end
      @balance = balance
    end

    #Allows withdraw unless final balance is less than 0
    def withdraw(amt)
     unless (@balance - amt) < 0
       @balance -= amt
     else
       puts "There aren't enough funds to complete this transaction."
       return @balance
     end
    end

    def deposit(amt)
      @balance += amt
    end

    def add_owner(owner)
      @owner = owner
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
  sample = Account.new(001,800)
  p sample.withdraw(100)
  p sample.balance
  p sample.withdraw(1000000)
  p sample.balance
  p sample.deposit(1000)
  p sample.balance
  sample_owner = Owner.new("Olivia","100 Ada Road")
  sample.add_owner(sample_owner)
  p sample.owner
end
