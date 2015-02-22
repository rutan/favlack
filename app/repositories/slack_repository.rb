class SlackRepository
  def client
    @client ||= Slack.client
  end
end
