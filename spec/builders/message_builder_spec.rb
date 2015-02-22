require 'rails_helper'

RSpec.describe MessageBuilder, type: :model do
  describe '#build' do
    subject do
      builder = MessageBuilder.new(@repository_stub, message_item)
      builder.build
      builder.message
    end

    before :each do
      client_stub = double(Object)
      allow(client_stub).to receive(:users_info).and_return('id' => 'U12345',
                                                            'name' => 'ru_shalm',
                                                            'profile' => {
                                                              'icon_48' => 'http://...'
                                                            })
      allow(client_stub).to receive(:channels_info).and_return('id' => 'C12345',
                                                               'name' => 'general')
      @repository_stub = double(Object)
      allow(@repository_stub).to receive(:client).and_return(client_stub)

      message_item # call!!
    end

    context 'when new message' do
      let :message_item do
        Slacks::MessageItem.new('channel' => 'C12345',
                                'message' => {
                                  'user' => 'U12345',
                                  'text' => '٩(๑❛ᴗ❛๑)۶',
                                  'ts' => '1234567.890',
                                  'permalink' => 'http://...'
                                }
        )
      end

      it { should be_truthy }
      it { expect { subject }.to change(Message, :count).by(1) }
    end

    context 'when exist message' do
      let :message_item do
        message = FactoryGirl.create(:message, :with_user, :with_channel)
        Slacks::MessageItem.new('channel' => message.channel.uid,
                                'message' => {
                                  'user' => message.user.uid,
                                  'text' => message.body,
                                  'ts' => message.ts,
                                  'permalink' => message.permalink
                                }
        )
      end

      it { should be_truthy }
      it { expect { subject }.not_to change(Message, :count) }
    end
  end
end
