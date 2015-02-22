require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do
  describe '#index' do
    subject { get :index }
    it { should have_http_status(:ok) }
    it { should render_template(:index) }
  end

  describe '#popular' do
    subject { get :popular }
    it { should have_http_status(:ok) }
    it { should render_template(:index) }
  end
end
