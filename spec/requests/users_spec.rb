require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "GET /users/:id/account" do
    let(:user) { create(:user) }

    it "returns account information" do
      get account_user_path(user), as: :json

      expect(response)
        .to have_http_status(:ok)

      body = response.parsed_body

      expect(body)
        .to include("id" => user.account.id, "user_id" => user.id)

      expect(body["balance"]["currency"])
        .to eq("USD")
    end
  end
end
