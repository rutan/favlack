namespace :import_stars do
  desc '指定ユーザのStarを取得'
  task :run, [:uid] => :environment do |_task, args|
    uid = args.uid
    fail 'invald user id' if uid.to_s.length < 2

    builder = StarListBuilder.new(SlackRepository.new, uid)
    builder.build
    log "finish! (added #{builder.stars.size} stars)"
  end

  def log(str)
    Rails.logger.info(str)
    puts str
  end
end
