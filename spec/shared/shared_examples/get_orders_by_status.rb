shared_examples "get_orders_by_status" do |status|
  let(:status) { status }

  it do
    expect(response).to be_successful
    expect(response).to render_template :index
    expect(assigns[:orders]).to eq [order]
  end
end
