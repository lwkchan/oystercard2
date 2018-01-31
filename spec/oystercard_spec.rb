require 'oystercard'

describe Oystercard do
  subject(:oystercard) { described_class.new }
  let(:entry_station) { double :station }
  let(:exit_station) { double :station }

  describe '#initialize' do

    context 'when initialize is passed argument' do
      subject(:oystercard) { described_class.new(Oystercard::MINIMUM_BALANCE) }
      it 'balance equals argument' do
        expect(oystercard.balance).to eq Oystercard::MINIMUM_BALANCE
      end
    end

    context 'when initialize not passed argument' do
      it 'balance equals default balance' do
        expect(oystercard.balance).to eq Oystercard::DEFAULT_BALANCE
      end
    end
  end

  describe '#top_up' do

    context 'when top_up is passed an argument' do
      it 'tops up the oyster card' do
        expect { oystercard.top_up(Oystercard::MINIMUM_BALANCE) }.to change{ oystercard.balance }.by(Oystercard::MINIMUM_BALANCE)
      end
    end

    context 'when top-up balance exceeds maximum limit' do
      it 'raises an error when top-up limit is exceeded' do
        error_message = "Maximum balance of #{Oystercard::MAXIMUM_LIMIT} exceeded!"
        top_up_amount = Oystercard::MAXIMUM_LIMIT - oystercard.balance + 1
        expect { oystercard.top_up(top_up_amount) }.to raise_error error_message
      end
      it 'returns whether or not the card is in journey' do
        expect(oystercard.in_journey?).to eq(true).or eq(false)
      end
    end
  end

  describe '#touch_in' do

    context 'when touch_in is passed an argument' do
      it 'starts journey' do
        expect { oystercard.touch_in(entry_station) }.to change { oystercard.in_journey? }.from(false).to(true)
      end

      it 'remembers and stores the argument (entry station)' do
        expect { oystercard.touch_in(entry_station) }.to change { oystercard.entry_station }.to eq entry_station
      end
    end

    context '#when the balance is too low' do
      it 'raises an error when the balance is less than the minumum amount' do
        allow(oystercard).to receive(:balance).and_return(0)
        low_credit = 'There is not enough credit on your card!'
        expect { oystercard.touch_in(entry_station) }.to raise_error low_credit
      end
    end
  end

  describe '#touch_out' do

    before(:each) do
      oystercard.touch_in(entry_station)
    end

    context '#when touch_out is called' do
      it 'ends the current journey' do
        expect { oystercard.touch_out(exit_station) }.to change { oystercard.in_journey? }.from(true).to(false)
      end

      it 'stores an exit station' do
        allow(oystercard).to receive(:exit_station).and_return(exit_station)
        oystercard.touch_out(exit_station)
        expect(oystercard.exit_station).to eq exit_station
      end

      it 'resets the journey history' do
        expect { oystercard.touch_out(exit_station) }.to change { oystercard.entry_station }.to be nil
      end

      it 'deducts fare from the oyster card' do
        expect{oystercard.touch_out(exit_station)}.to change{oystercard.balance}.by(-Oystercard::FARE)
      end
    end
  end
end
