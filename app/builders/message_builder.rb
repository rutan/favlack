class MessageBuilder
  def initialize(slack_repository, message_item)
    @repository = slack_repository
    @message_item = message_item
    @message = nil
  end

  attr_reader :message

  def build
    return unless @message_item.human?
    return if channel.hidden?
    @message = Message.find_or_initialize_by(channel_id: channel.id, ts: @message_item.ts)

    return unless @message.new_record?
    @message.user = user
    @message.channel = channel
    @message.body = @message_item.text
    @message.permalink = @message_item.permalink
    @message.save!
  end

  def channel
    @channel ||= Channel.find_or_initialize_by(uid: @message_item.channel_id).tap do |channel|
      channel.fetch(@repository) if channel.new_record?
    end
  end

  def user
    @user ||= User.find_or_initialize_by(uid: @message_item.user_id).tap do |user|
      user.fetch(@repository) if user.new_record?
    end
  end
end
