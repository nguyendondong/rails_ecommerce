require "rails_helper"

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create :user }
  
  describe "validates" do
    it do
      is_expected.to validate_presence_of(:name)
      is_expected.to validate_length_of(:name).is_at_most(50)
      is_expected.to define_enum_for(:role).with_values(%i(user admin))
      is_expected.to define_enum_for(:status).with_values(%i(enabled disabled))
    end
  end

  describe "associations" do
    it do
      is_expected.to have_many(:orders)
      is_expected.to have_many(:order_items).through(:orders)
    end
  end

  describe "methods" do
    describe "#confirmation_required?" do
      subject { user.confirmation_required? }

      let(:user) { FactoryBot.create :user, role: role }

      context "when user is role: admin" do
        let(:role) { :admin }
        
        it { is_expected.to be false }
      end

      context "when user is role: user" do
        let(:role) { :user }

        it { is_expected.to be true }
      end
    end
  
    describe "#active_for_authentication?" do
      subject { user.active_for_authentication? }

      let(:user) { FactoryBot.create :user, status: status }

      context "when user's status is enabled" do
        let(:status) { :enabled }
        
        it { is_expected.to be true }
      end

      context "when user's status is disabled" do
        let(:status) { :disabled }
        
        it { is_expected.to be false }
      end
    end

    describe "#send_devise_notification?" do
      before do
        allow(Devise.mailer).to receive(:confirmation_instructions).and_return(double(deliver_later: true))
        user.send_devise_notification(:confirmation_instructions)
      end
  
      it {expect(Devise.mailer).to have_received(:confirmation_instructions).with(user)}
    end
  end
end
