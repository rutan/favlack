class ChannelsController < ApplicationController
  def index
    @channels = Channel.list
  end

  def show
    @channel = Channel.find_by!(name: params[:id])
    @type = sort_type
    @messages =
      case @type
      when :popular
        @channel.messages.popular.page(page)
      else
        @channel.messages.list.page(page)
      end
  end
end
