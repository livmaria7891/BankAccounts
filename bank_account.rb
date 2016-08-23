module Bank
  class Account

    attr_reader :balance

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
       puts "You can't do that.. You're broke!"
       return @balance
     end
    end

    def deposit(amt)
      @balance += amt
    end

  end

  class Owner

    def initialize(name, address)
      @name = name
      @address = address
    end

  end

end
