class Oystercard

  DEFAULT_BALANCE = 5
  MINIMUM_BALANCE = 1
  MAXIMUM_LIMIT = 90
  FARE = 7
  attr_reader :balance, :entry_station

  def initialize(balance = DEFAULT_BALANCE)
    @balance = balance
    @in_journey = false
    @entry_station = []
  end

  def top_up(amount)
    raise "Maximum balance of #{MAXIMUM_LIMIT} exceeded!" if limit_reached?(amount)
    @balance += amount
  end

  def in_journey?
    @in_journey
  end

  def touch_in
    @entry_station << "Makers Academy"
    raise "There is not enough credit on your card!" if balance < MINIMUM_BALANCE
    @in_journey = true
  end

  def touch_out
    deduct(FARE)
    puts "Deducted #{FARE} from balance!"
    @in_journey = false
  end

  private

  def limit_reached?(amount)
    (@balance + amount) > MAXIMUM_LIMIT
  end

  def deduct(fare)
    @balance -= fare
  end
end
