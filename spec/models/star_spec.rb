require 'rails_helper'

RSpec.describe Star, type: :model do
  describe '#save' do
    subject { star.save! }
    before(:each) { star.message = message }
    let(:star) { FactoryGirl.build(:star, :with_user) }
    let(:message) { FactoryGirl.create(:message, :with_user, :with_channel) }

    it do
      expect(message).to receive(:calc_score)
      subject
    end

    it { expect { subject }.to change { message.score }.by(1) }
  end

  describe '#destroy' do
    subject { star.destroy }
    before :each do
      star.message = message
      star.save
    end
    let(:star) { FactoryGirl.build(:star, :with_user) }
    let(:message) { FactoryGirl.create(:message, :with_user, :with_channel) }

    it do
      expect(message).to receive(:calc_score)
      subject
    end

    it { expect { subject }.to change { message.score }.by(-1) }
  end
end
