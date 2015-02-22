require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#fetch' do
    subject do
      @user.fetch(repository)
    end
    before(:each) { @user = user }

    let(:repository) do
      double(Object).tap do |stub|
        allow(stub).to receive(:client).and_return(slack_client)
      end
    end

    let(:slack_client) do
      client_stub = double(Object)
      allow(client_stub).to receive(:users_info).and_return(
        'ok' => true,
        'user' => {
          'id' => 'U12345',
          'name' => 'ru_shalm',
          'deleted' => false,
          'color' => '00ff00',
          'profile' => {
            'first_name' => 'Ru',
            'last_name' => 'MuckRu',
            'real_name' => 'Ru/MuckRu',
            'email' => 'ru_shalm@hazimu.com',
            'image_24' => 'https://...',
            'image_32' => 'https://...',
            'image_48' => 'https://...',
            'image_72' => 'https://...',
            'image_192' => 'https://...'
          },
          'is_admin' => false,
          'is_owner' => false,
          'has_files' => false
        }
      )
      client_stub
    end

    context 'new user' do
      let(:user) { FactoryGirl.build(:user) }

      it { should be_truthy }
      it { expect { subject }.to change(User, :count).by(1) }
    end

    context 'update user' do
      let(:user) { FactoryGirl.create(:user) }

      it { should be_truthy }
      it { expect { subject }.not_to change(User, :count) }
    end

    context 'invalid user' do
      let(:user) { FactoryGirl.build(:user) }

      let(:slack_client) {
        client_stub = double(Object)
        allow(client_stub).to receive(:users_info).and_return(
          'ok' => false
        )
        client_stub
      }

      it { should be_falsey }
      it { expect { subject }.not_to change(User, :count) }
    end
  end
end
