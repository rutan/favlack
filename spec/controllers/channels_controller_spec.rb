require 'rails_helper'

RSpec.describe ChannelsController, type: :controller do
  describe '#index' do
    subject { get :index }
    it { should have_http_status(:ok) }
    it { should render_template(:index) }
  end

  describe '#show' do
    subject { get :show, id: param }

    context 'when valid channel' do
      let(:param) { FactoryGirl.create(:channel).to_param }

      it { should have_http_status(:ok) }
      it { should render_template(:show) }
    end

    context 'when invalid channel' do
      let(:param) { 'invalid_channel' }

      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end
end
