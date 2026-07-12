json.array! @orders do |order|
  json.id order.id
  json.status order.status
  json.amount do
    json.value order.amount.to_s
    json.currency order.amount.currency.iso_code
  end
end
