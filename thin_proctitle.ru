class ProcTitle

  def initialize(app)
    @app = app
  end

  def call(env)
    $0 = "thin [#{env['SERVER_PORT']}/-/-]: handling #{env['SERVER_NAME']}: #{env['REQUEST_METHOD']} #{env['PATH_INFO']}"
    @app.call(env)
  end

end
use ProcTitle
run Rack::Adapter::Rails.new(:root => '/your/rails/root/dir', :environment => 'production')

