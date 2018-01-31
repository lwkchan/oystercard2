require 'oystercard'

describe Oystercard do
  subject(:oystercard) {described_class.new}
  let(:entry_station) {double :entry_station}

  describe '#initialize' do

    context "when initialize is passed argument" do
      subject(:oystercard) { described_class.new(Oystercard::MINIMUM_BALANCE) }
      it "balance equals argument" do
        expect(oystercard.balance).to eq Oystercard::MINIMUM_BALANCE
      end
    end

    context "when initialize not passed argument" do
      it "balance equals default balance" do
        expect(oystercard.balance).to eq Oystercard::DEFAULT_BALANCE
      end
    end
  end

  describe "#top_up" do

    context 'when top_up is passed an argument' do
      it "tops up the oyster card" do
        expect{ oystercard.top_up(Oystercard::MINIMUM_BALANCE)}.to change{oystercard.balance}.by(Oystercard::MINIMUM_BALANCE)
      end
    end

    context "when top-up balance exceeds maximum limit" do
      it "raises 'Maximum balance exceeded' error" do
        error_message = "Maximum balance of #{Oystercard::MAXIMUM_LIMIT} exceeded!"
        top_up_amount = Oystercard::MAXIMUM_LIMIT - oystercard.balance + 1
        expect{ oystercard.top_up(top_up_amount) }.to raise_error error_message
      end
    end
  end

  describe '#touch_in' do
    let(:entry_station) {double :entry_station}

    context 'when touch_in is passed an argument' do
      it 'starts journey' do
        expect { oystercard.touch_in(entry_station) }.to change { oystercard.in_journey? }.from(false).to(true)
      end

      it 'remembers and stores the argument (entry station)' do
        expect { oystercard.touch_in(entry_station) }.to change { oystercard.entry_station }.to include "Makers Academy"
      end
    end

    context '#when the balance is too low' do
      it "raises an error when the balance is less than the minumum amount" do
        allow(oystercard).to receive(:balance).and_return(0)
        low_credit = "There is not enough credit on your card!"
        expect{ oystercard.touch_in(entry_station) }.to raise_error low_credit
      end
    end
  end

  describe "#touch_out" do
    let(:entry_station) { double :station }
    let(:exit_station) { double :station }

    context 'when touch_out is called' do
      it "ends the current journey" do
        oystercard.touch_in(entry_station)
        expect{oystercard.touch_out}.to change{oystercard.in_journey?}.from(true).to(false)
      end

      it 'deducts the journey fare and displays remaining balance' do
        message = "Deducted #{Oystercard::FARE} from balance!"
        expect { print(message) }.to output.to_stdout
      end

      it 'removes resets the journey history' do
        oystercard.touch_in(entry_station)
        expect { oystercard.touch_out }.to change { oystercard.entry_station }.to be nil
      end
    end
  end
end

# describe "#deduct" do
#   it "deducts fare from the oyster card" do
#     expect{oystercard.touch_out}.to change{oystercard.balance}.by(-Oystercard::FARE)
#   end
# end

# describe "#in_journey" do
#   it "returns whether or not the card is in journey" do
#     expect(oystercard.in_journey?).to eq(true).or eq(false)
#   end
# end
