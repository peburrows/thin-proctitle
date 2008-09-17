module Rack

  class Response
    def new_finish
      $0 = "thin [#{$port}/-/#{$count}]: idle"
      old_finish
    end
    alias_method :old_finish, :finish
    alias_method :finish, :new_finish
  end
  
  class File
    # for some reason, serving a file doesn't call the finish method...
    def new_call(env)
      k = old_call(env)
      $0 = "thin [#{env['SERVER_PORT']}/-/#{$count}]: idle"
      k
    end
    alias_method :old_call, :call
    alias_method :call, :new_call
  end
end

class ProcTitle

  def initialize(app)
    @app = app
    $count = 0
  end
 
  def call(env)
    $count += 1
    $port = env['SERVER_PORT']
    $0 = "thin [#{env['SERVER_PORT']}/-/#{$count}]: handling #{env['SERVER_NAME']}: #{env['REQUEST_METHOD']} #{env['PATH_INFO']}"
    @app.call(env)
  end
end
use ProcTitle
run Rack::Adapter::Rails.new(:root => '/your/rails/root/dir', :environment => 'production')

