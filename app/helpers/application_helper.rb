module ApplicationHelper
  def site_title
    ENV['SITE_TITLE'] || 'Favlack'
  end

  def render_markdown(src)
    @processor ||= SlackMessageMarkdown::Processor.new(
      asset_root: '/assets',
      cushion_link: "#{cushion_path}?url="
    )
    @context ||= {
      original_emoji_set: Rails.cache.fetch('emoji_data', expires_in: 1.hours) {
        SlackRepository.new.client.emoji_list['emoji'] || {}
      },
      on_get_user: -> (uid) {
        Rails.cache.fetch("user_data_#{uid}", expires_in: 1.hours) do
          user = User.find_and_fetch(SlackRepository.new, uid)
          user ? { name: user.name, url: user_path(user) } : nil
        end
      },
      on_get_channel: -> (uid) {
        Rails.cache.fetch("channel_data_#{uid}", expires_in: 1.hours) do
          channel = Channel.find_or_fetch(SlackRepository.new, uid)
          channel ? { name: channel.name, url: channel_path(channel) } : nil
        end
      }
    }
    @processor.call(src, @context)[:output].to_s.html_safe
  end
end
