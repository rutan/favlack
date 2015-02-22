require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe '#show' do
    subject { get :show, id: param }

    context 'when valid user' do
      let(:param) { FactoryGirl.create(:user).to_param }

      it { should have_http_status(:ok) }
      it { should render_template(:show) }
    end

    context 'when invalid user' do
      let(:param) { 'invalid_user' }

      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end
end
