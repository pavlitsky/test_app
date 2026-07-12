class UsersController < ApplicationController
  before_action :set_user, only: %i[account]

  def account
    @account = @user.account

    render :account, formats: [ :json ]
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
