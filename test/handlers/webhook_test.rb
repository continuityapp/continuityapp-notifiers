require File.expand_path('../../helper', __FILE__)

class WebhookTest < NotificationHandler::TestCase
  fixtures :dependency

  def setup
    @request_stub = stub_request(:post, "http://hooks.continuityapp.com/receive").
        with(:body => "notification_type=DEPENDENCY_COMPILATION_SUCCESS&data[id]=64734563785638&data[name]=i%20am%20cool").
        to_return(:status => 200, :body => "", :headers => {})

    @webhook = NotificationHandler::Webhook.new
  end

  def test_post
    EventMachine.synchrony do
        @webhook.perform(
            NotificationHandler::DEPENDENCY_COMPILATION_SUCCESS, 
            sc({"url" => "http://hooks.continuityapp.com/receive"}),
            sc(dependency(:compiled)))
        EventMachine.stop
    end
  
    assert_requested @request_stub
  end
end