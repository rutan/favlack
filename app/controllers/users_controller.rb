class UsersController < ApplicationController
  def show
    @user = User.find_by!(name: params[:id])
    @type = sort_type
    @messages =
      case @type
      when :popular
        @user.messages.popular.page(page)
      else
        @user.messages.list.page(page)
      end
  end

  def mine
    @user = User.find_by!(name: params[:id])
    @type = :mine
    @messages = @user.star_messages.page(page)
    render action: :show
  end
end
