require 'journey'

describe Journey do

  subject(:journey) { described_class.new(entry_station,exit_station) }
  let (:entry_station) { double('entry_station') }
  let (:exit_station) { double('exit_station') }

  it "has an entry_station property" do
    expect(journey.entry_station).to eq entry_station
  end

  it "has an exit_station property" do
    expect(journey.exit_station).to eq exit_station
  end



end
