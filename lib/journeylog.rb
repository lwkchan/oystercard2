class JourneyLog

  attr_reader :current_journey, :journeys

  def initialize(journey_class)
    @current_journey = journey_class
    @journeys = []
  end

  def starting(station)
    @current_journey.set_entry(station)
  end
end
