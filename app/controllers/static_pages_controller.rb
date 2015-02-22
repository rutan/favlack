class StaticPagesController < ApplicationController
  def index
    @type = :new
    @messages = Message.list.page(page)
  end

  def popular
    @type = :popular
    @messages = Message.popular.page(page)
    render action: :index
  end

  def cushion
    @url = params[:url].to_s.strip
    if @url.match(/\Ahttps?:\/\//)
      render layout: false
    else
      redirect_to '/'
    end
  end
end
