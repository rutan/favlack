class MessagesController < ApplicationController
  def show
    @channel = Channel.find_by!(name: params[:channel_id])
    @message = Message.find_by!(channel_id: @channel.id, ts: params[:ts])
  end
end
