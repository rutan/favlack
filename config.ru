# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment', __FILE__)
run Rails.application

if ENV['WITH_WORKER'].present?
  EM.defer do
    begin
      repo = SlackRepository.new
      worker = SlackReceivingWorker.new(repo)
      worker.start
    rescue => e
      Rails.logger.error e.inspect
      sleep 5
      retry
    end
  end
end
