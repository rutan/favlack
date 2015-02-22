require 'rails_helper'

RSpec.describe Slacks::ChannelItem, type: :model do
  describe '.public?' do
    subject do
      Slacks::ChannelItem.new('id' => id, 'name' => 'general').public?
    end

    context 'when id: C12345' do
      let(:id) { 'C12345' }
      it { should be_truthy }
    end

    context 'when id: G12345' do
      let(:id) { 'G12345' }
      it { should be_falsey }
    end
  end
end
