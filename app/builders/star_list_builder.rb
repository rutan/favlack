class StarListBuilder
  def initialize(slack_repository, uid)
    @repository = slack_repository
    @uid = uid
    @stars = []
  end

  attr_reader :stars

  def build
    response = @repository.client.stars_list(user: user.uid)
    puts response.inspect
    response['items'].each do |response_item|
      wrapper = {
        'user' => user.uid,
        'event_ts' => '0',
        'item' => response_item
      }
      puts wrapper.inspect
      item = Slacks::StarItem.new(wrapper)
      next unless item.message?
      next unless item.item.public?
      message_builder = MessageBuilder.new(@repository, item.item)
      message_builder.build
      @stars.push Star.link(user, message_builder.message) if message_builder.message
    end
  end

  def user
    @user ||= User.find_or_initialize_by(uid: @uid).tap do |user|
      user.fetch(@repository) if user.new_record?
    end
  end
end
