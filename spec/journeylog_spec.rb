require 'journeylog'

describe JourneyLog do
  subject(:journeylog) { described_class.new(journey) }
  let(:journey) { double('journey') }


  it 'is initialized with a new journey' do
    expect(journeylog.current_journey).to eq journey
  end

  it 'is initialized with an empty journeys array' do
    expect(journeylog.journeys).to eq []
  end

  describe '#starting' do

    it 'sets the entry station of the current_journey' do

    end

  end

end
