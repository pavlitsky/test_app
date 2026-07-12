json.id @account.id
json.user_id @account.user_id
json.balance do
  json.value @account.balance.to_s
  json.currency @account.balance.currency.iso_code
end
