class NotificationHandler::Webhook < NotificationHandler
  def notify
    EventMachine::HttpRequest.new(@options['url']).post :body => {'notification_type' => @notification_type, 'data' => @payload}
    # p shorten_url('https://continuityapp.com')
  end
end