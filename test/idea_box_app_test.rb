require './test/test_helper'
require 'sinatra/base'
require 'rack/test'
require './lib/app'

class IdeaboxAppHelper < Minitest::Test

  include Rack::Test::Methods

  def app
    IdeaBoxApp
  end

  def test_page_loads
    get '/'
    assert last_response.body.include? "IdeaBox"
  end

end
