require "rails_helper"

RSpec.describe Order, type: :model do
  describe "validates" do
    it do
      is_expected.to validate_presence_of(:phone)
      is_expected.to validate_presence_of(:address)
      is_expected.to define_enum_for(:status).with_values(%i(wait_confirm delivering completed canceled))
    end
  end

  describe "associations" do
    it do
      is_expected.to have_many(:order_items)
      is_expected.to have_many(:products).through(:order_items)
      is_expected.to belong_to(:user)
    end
  end

  describe "callbacks" do
    let(:product) { FactoryBot.create :product, price: 20 }
    let(:order_item) { FactoryBot.create :order_item, product: product }
    let!(:order) { FactoryBot.create :order, order_items: [order_item] }

    describe "#calculate_total_price" do
      it { expect(order.total_price).to eq(20.0) }
    end

    describe "#update_sold_product" do
      subject { order.update(status: status) }

      context "when update order's status is completed" do
        let(:status) { :completed }
        
        it { expect { subject }.to change(product, :sold).from(0).to(1) }
      end

      context "when update order's status is't completed" do
        let(:status) { :delivering }

        it { expect { subject }.not_to change(product, :sold) }
      end
    end
  end

  describe "scopes" do
    describe "default scope" do
      let!(:order_1) { FactoryBot.create :order }
      let!(:order_2) { FactoryBot.create :order }

      it { expect(described_class.ids).to eq [order_2.id, order_1.id] }
    end

    describe "#this_month" do
      subject { described_class.this_month }

      let!(:order) { FactoryBot.create :order, created_at: created_at }

      context "when order in this month" do
       let(:created_at) { Time.zone.now }

        it { is_expected.to eq [order] }
      end

      context "when order not in this month" do
        let(:created_at) { Time.zone.now - 1.month }

        it { is_expected.to eq [] }
      end
    end
  end
end
