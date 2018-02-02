require_relative 'journey'

class Oystercard
  DEFAULT_BALANCE = 5
  MINIMUM_BALANCE = 1
  MAXIMUM_LIMIT = 90

  attr_reader :balance, :journey_history, :current_journey

  def initialize(balance = DEFAULT_BALANCE)
    @balance = balance
    @journey_history = []
    # @journey_log = JourneyLog.new
    @current_journey = Journey.new
  end

  def top_up(amount)
    raise "Maximum balance of #{MAXIMUM_LIMIT} exceeded!" if limit_reached?(amount)
    @balance += amount
  end

  def touch_in(entry_station)
    complete_journey if !current_journey.complete? || !current_journey.new?
    @current_journey.entry_station = entry_station
    raise 'There is not enough credit on your card!' if balance < MINIMUM_BALANCE
  end

  def touch_out(exit_station)
    @current_journey.exit_station = exit_station
    complete_journey
  end

  private

  def limit_reached?(amount)
    (@balance + amount) > MAXIMUM_LIMIT
  end

  def complete_journey
    deduct(@current_journey.fare)
    @journey_history << @current_journey
    @current_journey = Journey.new
  end

  def deduct(fare)
    @balance -= fare
  end
end
