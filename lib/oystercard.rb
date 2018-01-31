class Oystercard
  DEFAULT_BALANCE = 5
  MINIMUM_BALANCE = 1
  MAXIMUM_LIMIT = 90
  FARE = 7
  attr_reader :balance, :entry_station

  def initialize(balance = DEFAULT_BALANCE)
    @balance = balance
    @entry_station = nil
  end

  def top_up(amount)
    raise "Maximum balance of #{MAXIMUM_LIMIT} exceeded!" if limit_reached?(amount)
    @balance += amount
  end

  def in_journey?
    !!entry_station
  end

  def touch_in(_entry_station)
    @entry_station = 'Makers Academy'
    raise 'There is not enough credit on your card!' if balance < MINIMUM_BALANCE
  end

  def touch_out
    deduct(FARE)
    @entry_station = nil
    puts "Deducted #{FARE} from balance!"
  end

  private

  def limit_reached?(amount)
    (@balance + amount) > MAXIMUM_LIMIT
  end

  def deduct(fare)
    @balance -= fare
  end
end
