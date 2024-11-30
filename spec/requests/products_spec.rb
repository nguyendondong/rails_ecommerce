require "rails_helper"

RSpec.describe ProductsController, type: :controller do
  let(:status) { :enabled }
  let!(:product_1) { create :product, status: status, price: 200000 }

  describe "GET #index" do
    before { get :index, params: { q: q_params } }

    context "when search with name/description" do
      let(:q_params) do 
        { 
          name_or_action_text_rich_text_body_cont: product_1.name,
          category_id_eq: product_1.category.id
        }
      end

      it do
        expect(assigns(:products)).to eq [product_1]
        expect(response).to render_template :index
      end
    end

    context "when search with price & sort" do
      let!(:product_2) { create :product, price: 300000 }
      let(:q_params) { { price_gteq: "50000", s: ["price desc"] } }

      it do
        expect(assigns(:products)).to eq [product_2, product_1]
        expect(response).to render_template :index
      end
    end
  end

  describe "GET #show" do
    let(:params) { { id: product_1.id } }

    before { get :show, params: params }

    context "When enabled product" do
      it do
        expect(assigns(:product)).to eq(product_1)
        expect(response).to render_template(:show)
      end
    end

    context "when disabled product" do
      let(:status) { :disabled }
      let(:expect_message) { "The product has been disabled and is not visible on websites" }

      it do
        expect(flash[:error]).to eq expect_message
        expect(response).to redirect_to products_path
      end
    end

    context "when product not exists" do
      let(:params) { { id: 0 } }

      it do
        expect(flash[:error]).to eq("Product isn't exist!")
        expect(response).to redirect_to products_path
      end
    end
  end
end
