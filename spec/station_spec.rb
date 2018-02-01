require 'station'

describe Station do
  subject(:station) { described_class.new("Victoria", 1) }

  describe '#initialize' do
    it 'defines a station name' do
      expect(station.name).to eq("Victoria")
    end

    it 'defines a station zone' do
      expect(station.zone).to eq(1)
    end
  end
end
