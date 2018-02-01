require 'journey'

describe Journey do

  subject(:journey) { described_class.new }
  let (:entry_station) { double('entry_station') }
  let (:exit_station) { double('exit_station') }

  it "stores an entry_station property" do
    journey.entry_station = entry_station
    expect(journey.entry_station).to eq entry_station
  end

  it "has an exit_station property" do
    journey.exit_station = exit_station
    expect(journey.exit_station).to eq exit_station
  end

  describe '#fare' do
    it "returns the minimum fare for a complete journey" do
      journey.entry_station = entry_station
      journey.exit_station = exit_station
      expect(journey.fare).to eq Journey::MINIMUM_FARE
    end

    it "returns a penalty fare for an incomplete journey" do
      journey.exit_station = exit_station
      expect(journey.fare).to eq Journey::PENALTY_FARE
    end

  end
end
