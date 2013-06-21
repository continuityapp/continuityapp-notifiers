require File.expand_path('../../helper', __FILE__)

class NotificationHandlerTest < NotificationHandler::TestCase
  def setup
    @request_stub = stub_request(:post, "http://capp.me/api/add").
    with(:body => "url=https%3A%2F%2Fcontinuityapp%2Flong-url&api_key=0k3jhfU4RbE7268JygeOiw5Y91nZcC").
    to_return(:status => 200, :body => "http://capp.me/2", :headers => {})

    @handler = NotificationHandler.new
  end

  def test_create_short_url    
    EventMachine.synchrony do
      short_url = @handler.shorten_url('https://continuityapp/long-url')
      EventMachine.stop
    
      assert_equal('http://capp.me/2', short_url)
    end
  
    assert_requested @request_stub
  end
end