shared_examples "user_not_login" do
  context "when user not login" do
    let(:expect_message) { "You are not authorized to access this page." }
  
    before { subject }
  
    it do
      expect(response).to redirect_to root_path
      expect(flash[:error]).to eq expect_message
    end
  end
end
