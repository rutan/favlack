require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  describe '#show' do
    subject { get :show, params }

    context 'when valid user' do
      let(:params) {}
      let(:params) do
        message = FactoryGirl.create(:message, :with_user, :with_channel)
        {
          'channel_id' => message.channel.name,
          'ts' => message.ts
        }
      end

      it { should have_http_status(:ok) }
      it { should render_template(:show) }
    end

    context 'when invalid user' do
      let(:params) do
        {
          'channel_id' => 'unknown',
          'ts' => 'hogefuga'
        }
      end

      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end
end
