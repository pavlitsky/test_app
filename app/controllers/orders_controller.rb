class OrdersController < ApplicationController
  before_action :set_order, only: %i[show complete cancel]

  def index
    @orders = Order.all
  end

  def show
    render :show, formats: [ :json ]
  end

  def create
    @order = current_user.orders.create!(order_params)

    render :show, status: :created, formats: [ :json ]
  end

  def complete
    Orders::Complete.call(@order)

    render :show, formats: [ :json ]
  end

  def cancel
    Orders::Cancel.call(@order)

    render :show, formats: [ :json ]
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:amount_cents)
  end
end
