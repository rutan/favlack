# SlackRTMの受信機
class SlackReceivingWorker
  # 初期化
  # @param [SlackRepository] repository
  def initialize(repository)
    @repository = repository
  end

  # RealTimeMessagingAPI接続開始
  def start
    @rtm_client = @repository.client.realtime

    @rtm_client.on :team_join, &method(:user_updated)
    @rtm_client.on :user_change, &method(:user_updated)

    @rtm_client.on :channel_created, &method(:channel_updated)
    @rtm_client.on :channel_rename, &method(:channel_updated)

    @rtm_client.on :star_added, &method(:star_added)
    @rtm_client.on :star_removed, &method(:star_removed)

    @rtm_client.start
  end

  # ユーザ情報の更新通知受信時
  # @param [Hash] response
  def user_updated(response)
    item = Slacks::UserItem.new(response['item'])
    user = User.find_or_initialize_by(uid: item.id)
    user.apply_item(item)
  rescue => e
    Rails.logger.error "#{e.inspect} - #{e.backtrace}"
  end

  # チャンネル情報の更新通知受信時
  # @param [Hash] response
  def channel_updated(response)
    item = Slacks::ChannelItem.new(response['channel'])
    return unless item.public?
    channel = Channel.find_or_initialize_by(uid: item.id)
    channel.apply_item(item)
  rescue => e
    Rails.logger.error "#{e.inspect} - #{e.backtrace}"
  end

  # スター追加の通知受信時
  # @param [Hash] response
  def star_added(response)
    item = Slacks::StarItem.new(response)
    return unless starable?(item)

    user = User.find_or_initialize_by(uid: item.user_id)
    user.fetch(@repository) if user.new_record?

    message_builder = MessageBuilder.new(@repository, item.item)
    message_builder.build
    Star.link(user, message_builder.message) if message_builder.message
  rescue => e
    Rails.logger.error "#{e.inspect} - #{e.backtrace}"
  end

  # スター削除の通知受信時
  # @param [Hash] response
  def star_removed(response)
    item = Slacks::StarItem.new(response)
    return unless starable?(item)

    user = User.find_by(uid: item.user_id)
    return unless user

    message_builder = MessageBuilder.new(@repository, item.item)
    message_builder.build
    Star.unlink(user, message_builder.message) if message_builder.message
  rescue => e
    Rails.logger.error "#{e.inspect} - #{e.backtrace}"
  end

  private

  def starable?(item)
    return false unless item.message?
    return false unless item.item.public?
    return false unless item.item.human?
    true
  end
end
