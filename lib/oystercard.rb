require_relative 'journey'
require_relative 'journeylog'

class Oystercard
  DEFAULT_BALANCE = 5
  MINIMUM_BALANCE = 1
  MAXIMUM_LIMIT = 90

  attr_reader :balance, :journey_history, :current_journey

  def initialize(balance = DEFAULT_BALANCE)
    @balance = balance
    @journey_history = []
    @current_journey = Journey.new
    @journey_log = JourneyLog.new(@current_journey)
  end

  def top_up(amount)
    raise "Maximum balance of #{MAXIMUM_LIMIT} exceeded!" if limit_reached?(amount)
    @balance += amount
  end

  def touch_in(entry_station)
    complete_journey if !current_journey.complete? || !current_journey.new?
    @journey_log.starting(entry_station)
    raise 'There is not enough credit on your card!' if balance < MINIMUM_BALANCE
  end

  def touch_out(exit_station)
    @journey_log.ending(exit_station)
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
