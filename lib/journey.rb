class Journey

  MINIMUM_FARE = 3
  PENALTY_FARE = 6


  attr_accessor :entry_station, :exit_station

  def initialize
    @entry_station = nil
    @exit_station = nil
  end

  def fare
    return MINIMUM_FARE if complete?
    return PENALTY_FARE if !complete?
  end

  def complete?
    @entry_station != nil && @exit_station != nil
  end

  def set_entry(station)
    @entry_station = station
  end

  def set_exit(station)
    @exit_station = station
  end

  def new?
    @entry_station == nil && @exit_station == nil
  end
end
