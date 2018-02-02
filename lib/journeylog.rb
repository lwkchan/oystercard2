class JourneyLog

  attr_reader :current_journey, :journeys

  def initialize(journey_class)
    @current_journey = journey_class #Journey.new
    @journeys = []
  end

  def starting(station)
    @current_journey.set_entry(station)
  end

  def ending(station)
    @current_journey.set_exit(station)
  end

end
