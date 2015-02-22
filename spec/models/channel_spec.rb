require 'rails_helper'

RSpec.describe Channel, type: :model do
  describe '#fetch' do
    subject do
      @channel.fetch(repository)
    end
    before(:each) { @channel = channel }

    let(:repository) do
      double(Object).tap do |stub|
        allow(stub).to receive(:client).and_return(slack_client)
      end
    end

    let(:slack_client) do
      client_stub = double(Object)
      allow(client_stub).to receive(:channels_info).and_return(
        'ok' => true,
        'channel' => {
          'id' => 'C12345',
          'name' => 'general'
        }
      )
      client_stub
    end

    context 'new channel' do
      let(:channel) { FactoryGirl.build(:channel) }

      it { should be_truthy }
      it { expect { subject }.to change(Channel, :count).by(1) }
    end

    context 'update channel' do
      let(:channel) { FactoryGirl.create(:channel) }

      it { should be_truthy }
      it { expect { subject }.not_to change(Channel, :count) }
    end

    context 'invalid channel' do
      let(:channel) { FactoryGirl.build(:channel) }

      let(:slack_client) {
        client_stub = double(Object)
        allow(client_stub).to receive(:channels_info).and_return(
          'ok' => false
        )
        client_stub
      }

      it { should be_falsey }
      it { expect { subject }.not_to change(Channel, :count) }
    end
  end
end
