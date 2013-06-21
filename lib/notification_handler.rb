class NotificationHandler
  
  include Sidekiq::Worker
  sidekiq_options :retry => false

  # COMMITS
  COMMIT_WAITING_FOR_BUILDS             = 'COMMIT_WAITING_FOR_BUILDS'
  COMMIT_SUCCEED                        = 'COMMIT_SUCCEED'
  COMMIT_FAILED_NO_SUITES               = 'COMMIT_FAILED_NO_SUITES'
  COMMIT_FAILED                         = 'COMMIT_FAILED'
  COMMIT_BIASED                         = 'COMMIT_BIASED'

  # BUILD_REQUEST
  BUILD_REQUEST_FAILED_NO_SUITES        = 'BUILD_REQUEST_FAILED_NO_SUITES'
  BUILD_REQUEST_PROCESSING              = 'BUILD_REQUEST_PROCESSING'
  BUILD_REQUEST_PROCESSED               = 'BUILD_REQUEST_PROCESSED'

  # BUILD
  BUILD_ENQUEUED_FOR_BUILD              = 'BUILD_ENQUEUED_FOR_BUILD'
  BUILD_BUILDING                        = 'BUILD_BUILDING'
  BUILD_BUILD_FAILED                    = 'BUILD_BUILD_FAILED'
  BUILD_BUILD_SUCCEED                   = 'BUILD_BUILD_SUCCEED'

  # PROJECT
  PROJECT_UPDATING_REPOSITORY                     = 'PROJECT_UPDATING_REPOSITORY'
  PROJECT_UPDATE_REPOSITORY_TIMEOUT               = 'PROJECT_UPDATE_REPOSITORY_TIMEOUT'
  PROJECT_UPDATE_REPOSITORY_ERRORED               = 'PROJECT_UPDATE_REPOSITORY_ERRORED'
  PROJECT_UPDATE_REPOSITORY_ERRORED_NOBRANCHES    = 'PROJECT_UPDATE_REPOSITORY_ERRORED_NOBRANCHES'

  ENABLED_NOTIFICATIONS = [
    COMMIT_WAITING_FOR_BUILDS,
    COMMIT_SUCCEED,
    COMMIT_FAILED_NO_SUITES,
    COMMIT_FAILED,
    COMMIT_BIASED,
    BUILD_REQUEST_FAILED_NO_SUITES,
    BUILD_REQUEST_PROCESSING,
    BUILD_REQUEST_PROCESSED,
    BUILD_ENQUEUED_FOR_BUILD,
    BUILD_BUILDING,
    BUILD_BUILD_FAILED,
    BUILD_BUILD_SUCCEED,
    PROJECT_UPDATING_REPOSITORY,
    PROJECT_UPDATE_REPOSITORY_TIMEOUT,
    PROJECT_UPDATE_REPOSITORY_ERRORED,
    PROJECT_UPDATE_REPOSITORY_ERRORED_NOBRANCHES
  ]
  
  def perform(notification_type, notification_options, notification_payload)
    raise "#{notification_type} is not enabled" unless ENABLED_NOTIFICATIONS.include? notification_type

    @notification_type = notification_type
    @options = MessagePack.unpack(Vault.decrypt(notification_options))
    @payload = MessagePack.unpack(Vault.decrypt(notification_payload))

    notify
  end

  def shorten_url(url)
    http = EventMachine::HttpRequest.new('http://capp.me').post :body => {:url => url}
    http.errback { return url }
    http.callback {
      return (http.response_header.status == 201) ? http.response_header['LOCATION'] : url
    }
  end

  def notify
    raise 'Not implemented'
  end
end