user = User.find_or_create_by!(email: "test.example.com")
Account.find_or_create_by!(user_id: user.id, balance_cents: 50_00)
