require 'oystercard'
require 'journey'

describe Oystercard do
  subject(:oystercard) { described_class.new }
  let(:entry_station) { double :station }
  let(:exit_station) { double :station }
  let(:current_journey) { double :current_journey }

  describe '#initialize' do

    it 'defaults to an empty journey_history' do
      expect(oystercard.journey_history).to be_empty
    end

    it 'initiates a new journey object' do
      expect(oystercard.current_journey).to be_an_instance_of(Journey)
    end

    context 'when passed an argument' do
      subject(:oystercard) { described_class.new(Oystercard::MINIMUM_BALANCE) }
      it 'balance equals argument' do
        expect(oystercard.balance).to eq Oystercard::MINIMUM_BALANCE
      end
    end

    context 'when not passed argument' do
      it 'balance equals default balance' do
        expect(oystercard.balance).to eq Oystercard::DEFAULT_BALANCE
      end
    end
  end

  describe '#top_up' do

    context 'when passed an argument' do
      it 'tops up the oyster card' do
        expect { oystercard.top_up(Oystercard::MINIMUM_BALANCE) }.to change{ oystercard.balance }.by(Oystercard::MINIMUM_BALANCE)
      end
    end

    context 'when balance exceeds maximum limit' do
      it 'raises an error when top-up limit is exceeded' do
        error_message = "Maximum balance of #{Oystercard::MAXIMUM_LIMIT} exceeded!"
        top_up_amount = Oystercard::MAXIMUM_LIMIT - oystercard.balance + 1
        expect { oystercard.top_up(top_up_amount) }.to raise_error error_message
      end

    end
  end

  describe '#touch_in' do

    context 'when the balance is too low' do
      it 'raises an error when the balance is less than the minumum amount' do
        allow(oystercard).to receive(:balance).and_return(0)
        low_credit = 'There is not enough credit on your card!'
        expect { oystercard.touch_in(entry_station) }.to raise_error low_credit
      end
    end
  end

  describe '#touch_out' do

    before(:each) do
      oystercard.top_up(Oystercard::DEFAULT_BALANCE)
      oystercard.touch_in(entry_station)
    end

    context 'when called' do
      it 'saves a complete journey and stores to journey_history' do
        expect{oystercard.touch_out(exit_station)}.to change{oystercard.journey_history.count }.by(1)
      end

      it 'deducts fare from the oyster card' do
        p oystercard 
        expect{oystercard.touch_out(exit_station)}.to change{oystercard.balance}.by(-Journey::MINIMUM_FARE)
      end
    end
  end
end
