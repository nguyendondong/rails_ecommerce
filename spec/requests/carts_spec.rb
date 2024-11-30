require "rails_helper"

RSpec.describe CartsController, type: :controller do
  let!(:product_1) { create(:product, status: :enabled) }
  let!(:product_2) { create(:product, status: :enabled) }
  let!(:product_3) { create(:product, status: :disabled) }
  let(:cart_items) { { product_1.id => 1, product_2.id => 1, product_3.id => 1 }.to_json }

  before { request.cookies[:cart_items] = cart_items }

  shared_examples "callbacks" do
    describe "#cart_items" do
      it do
        expect { subject }.to change { assigns(:cart_items) }
                  .from(assigns(:cart_items)).to(result.transform_keys(&:to_s))
      end
    end

    describe "#reload_cart" do
      it do
        expect { subject }.to change { cookies[:cart_items] }
                .from(cart_items).to(result.to_json)
      end
    end
  end

  describe "GET #show" do
    subject { get :show }

    it_behaves_like "callbacks" do
      let(:result) { { product_1.id => 1, product_2.id => 1 } }
    end

    context "when show success" do
      before { subject }

      it do
        expect(assigns(:order)).to be_a_new(Order)
        expect(assigns(:products).ids).to eq([product_1.id, product_2.id])
        expect(response).to render_template(:show)
      end
    end
  end

  describe "POST #create" do
    subject { post :create, params: { product_id: product_1.id, quantity: 1 } }

    it_behaves_like "callbacks" do
      let(:result) { { product_1.id => 2, product_2.id => 1 } }
    end

    context "when create success" do
      before do
        request.env["HTTP_REFERER"] = cart_path
        subject
      end
  
      it do
        expect(flash[:notice]).to eq("Product added to cart!")
        expect(response).to redirect_to cart_path
      end
    end
  end

  describe "PATCH #update" do    
    subject { patch :update, params: { product_id: product_1.id, quantity: 2 } }

    it_behaves_like "callbacks" do
      let(:result) { { product_1.id => 2, product_2.id => 1 } }
    end

    context "when update success" do
      before { subject }
  
      it { expect(response).to redirect_to cart_path }
    end
  end

  describe "DELETE #destroy" do
    subject { delete :destroy, params: { product_id: product_1.id } }

    it_behaves_like "callbacks" do
      let(:result) { { product_2.id => 1 } }
    end

    context "when destroy success" do
      before { subject }

      it do
        expect(flash[:notice]).to eq "Product removed from cart!"
        expect(response).to redirect_to cart_path
      end
    end
  end
end
