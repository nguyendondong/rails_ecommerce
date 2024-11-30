require "rails_helper"

RSpec.describe OrdersController, type: :controller do
  include ActiveJob::TestHelper

  let(:user) { create :user }
  let!(:product) { create :product, status: :enabled }
  let(:invalid_product_id) { 0 }

  describe "GET #index" do
    subject { get :index }

    it_behaves_like "user_not_login"

    context "when user logged in" do
      let!(:order) { create :order, user: user, status: status }

      before { sign_in user }
      
      context "when get all orders success" do
        let(:status) { :wait_confirm }
  
        before { subject }
  
        it do
          expect(response).to be_successful
          expect(response).to render_template :index
          expect(assigns[:orders]).to eq [order]
        end
      end
  
      context "when get orders by status" do
        before { get :index, params: { status: status} }
        
        context "when status is delivering" do
          it_behaves_like "get_orders_by_status", :delivering
        end
  
        context "when status is completed" do
          it_behaves_like "get_orders_by_status", :completed
        end
  
        context "when status is canceled" do
          it_behaves_like "get_orders_by_status", :canceled
        end
      end
    end
  end

  describe "POST #create" do
    subject { post :create, params: { order: order_params } }

    let(:order_params) { { address: "123 Main St", phone: "123-456-7890" } }

    it_behaves_like "user_not_login"

    context "when user logged in" do
      let(:cart_items) { { product.id => 1 }.to_json }
  
      before do
        sign_in user
        request.cookies[:cart_items] = cart_items
      end
  
      after { clear_enqueued_jobs }
  
      context "when valid product and order params" do
        let(:order_mailer_jobs) do
          ActiveJob::Base.queue_adapter.enqueued_jobs.select do |job|
            job[:args][0] == "OrderMailer" && job[:args][1] == "place_order"
          end
        end

        let(:expect_message) { "Order successfully placed! Please check your email to track the notification" }
  
        it do
          expect { subject }.to change(Order, :count).by(1)
          expect(assigns(:cart_items)).to eq(JSON.parse(cart_items))
          expect(response.cookies[:cart_items]).to be_nil
          expect(response).to redirect_to orders_path
          expect(flash[:success]).to eq expect_message
          expect(order_mailer_jobs.size).to eq 1
        end
      end
  
      context "when invalid product" do
        let(:cart_items) { { invalid_product_id: 1 }.to_json }
        let(:order_params) { { address: "123 Main St", phone: "123-456-7890" } }
  
        it do
          expect { subject }.not_to change(Order, :count)
          expect(response).to redirect_to cart_path
          expect(flash[:error]).to eq "Product not found."
          expect(response.cookies["cart_items"]).to eq "{}"
        end
      end
  
      context "when invalid order params" do
        let(:order_params) { { address: "123 Main St" } }
        let(:expect_message) { "Order failed! Please fill out your address and phone" }

        it do
          expect { subject }.not_to change(Order, :count)
          expect(flash[:error]).to eq expect_message
          expect(response).to redirect_to cart_path
        end
      end
    end
  end

  describe "PATCH #update" do
    subject { patch :update, params: params }

    let(:params) { { id: order_id, order: { reason_description: "cancel this order", status: "cancel" } } }
    let(:order) { create :order, user: user, status: status }
    let(:status) { :wait_confirm }
    let(:order_id) { order.id }

    it_behaves_like "user_not_login"

    context "when user logged in" do
      before { sign_in user }
      
      context "when order's status is wait_confirm" do
        it do
          expect { subject }.to change { order.reload.status }.from("wait_confirm").to("canceled")
          expect(response).to redirect_to orders_path
        end
      end
  
      context "when order's status in't wait_confirm" do
        let(:status) { :delivering }
        let(:expect_message) { "Unable to cancel order when status isn't 'Wait for confirmation'" }

        it do
          expect { subject }.not_to change { order.reload.status }
          expect(response).to redirect_to orders_path
          expect(flash[:error]).to eq expect_message
        end
      end
  
      context "when order not exists" do
        let(:order_id) { invalid_product_id }
        let(:expect_message) { "Order not found" }

        before { subject }
  
        it do
          expect(response).to redirect_to orders_path
          expect(flash[:error]).to eq expect_message
        end
      end
    end
  end
end
