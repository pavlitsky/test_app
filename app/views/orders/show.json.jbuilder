json.id @order.id
json.status @order.status
json.amount do
  json.value @order.amount.to_s
  json.currency @order.amount.currency.iso_code
end
json.user_id @order.user_id
json.transactions do
  json.array! @order.account_transactions do |transaction|
    json.id transaction.id
    json.type transaction.transaction_type
    json.amount do
      json.value transaction.amount.to_s
      json.currency transaction.amount.currency.iso_code
    end
  end
end
