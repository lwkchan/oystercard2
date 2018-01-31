require 'oystercard'

describe Oystercard do
  subject(:oystercard) {described_class.new}
  let(:entry_station) {double :entry_station}

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

  describe "#top_up" do
    it "tops up the oyster card" do
      expect{ oystercard.top_up(Oystercard::MINIMUM_BALANCE)}.to change{oystercard.balance}.by(Oystercard::MINIMUM_BALANCE)
    end

    context "when top-up balance exceeds maximum limit" do
      it "raises 'Maximum balance exceeded' error" do
        error_message = "Maximum balance of #{Oystercard::MAXIMUM_LIMIT} exceeded!"
        top_up_amount = Oystercard::MAXIMUM_LIMIT - oystercard.balance + 1
        expect{ oystercard.top_up(top_up_amount) }.to raise_error error_message
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

  describe '#touch_in' do
    let(:entry_station) {double :entry_station}

    it "starts journey" do
      expect { oystercard.touch_in(entry_station) }.to change { oystercard.in_journey? }.from(false).to(true)
    end

    context '#when the balance is too low' do
      it "raises an error when the balance is less than the minumum amount" do
        allow(oystercard).to receive(:balance).and_return(0)
        low_credit = "There is not enough credit on your card!"
        expect{ oystercard.touch_in(entry_station) }.to raise_error low_credit
      end
    end

    context '#when an entry station is provided' do
      it 'remembers the entry station after touch_in' do
        expect { oystercard.touch_in(entry_station) }.to change { oystercard.entry_station }.to include "Makers Academy"
      end
    end
  end

  describe "#touch_out" do
    let(:entry_station) { double :station }
    let(:exit_station) { double :station }

    it "ends journey" do
      oystercard.touch_in(entry_station)
      expect{oystercard.touch_out}.to change{oystercard.in_journey?}.from(true).to(false)
    end

    context '#when fare is deducted' do
      it 'displays remaining balance' do
        message = "Deducted #{Oystercard::FARE} from balance!"
        expect { print(message) }.to output.to_stdout
      end
    end

    context '#when the journey is completed' do
      it 'removes the entry stations and resets the array' do
        oystercard.touch_in(entry_station)
        expect { oystercard.touch_out }.to change { oystercard.entry_station }.to be nil
      end
    end
  end
end
