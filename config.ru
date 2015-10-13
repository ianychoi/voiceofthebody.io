require 'rack/cors'
require 'rack/rewrite'

# Modified version of TryStatic, from rack-contrib
# https://github.com/rack/rack-contrib/blob/master/lib/rack/contrib/try_static.rb

use Rack::Rewrite do
  r301   %r(\/sensor\-module\/sensor-module\-changelog\.html$),  'https://www.simband.io/'
  r301   %r(\/simband\/simband\-changelog\.html$),  'https://www.simband.io/'
  r301   %r(\/simband\/development-kits\.html$),  'https://www.simband.io/'
  r301   %r(\/simband\/simband\-documentation\/simband\-source\-code\.html),  'https://www.simband.io/documentation/simband-documentation/'
  r301   %r(\/simband\/simband\-documentation\/simband\-adk\.html),  'https://www.simband.io/pages/simband-adk'
  r301   %r(\/sensor\-module\/schematics),  'https://www.simband.io/'
  r301   %r(\/privacy$),  'https://www.simband.io/documentation/about/privacy.html'
  r301   %r(\/simband\/faq\.html$),  'https://www.simband.io/documentation/faq.html'
  r301   %r(\/simband\/news\.html$),  'https://www.simband.io/'
  r301   %r(\/simband$),  'https://www.simband.io/documentation/simband-documentation/'
  r301   %r(\/simband\/$),  'https://www.simband.io/documentation/simband-documentation/'
  r301   %r(\/simband\/(.*)),  'https://www.simband.io/documentation/$1'
  r301   %r(\/sensor\-module\/$),  'https://www.simband.io/documentation/sensor-module-documentation/'
  r301   %r(\/sensor\-module$),  'https://www.simband.io/documentation/sensor-module-documentation/'
  r301   %r(\/sensor\-module\/(.*)),  'https://www.simband.io/documentation/$1'
  r301   %r(\/bioinformatics$),  'https://www.simband.io/bioinformatics/'
  r301   %r(\/bioinformatics\/(.*)),  'https://www.simband.io/bioinformatics/$1'
  r301   %r(\/community$),  'https://www.simband.io/'
  r301   %r(\/community\/(.*)),  'https://www.simband.io/'
  r301   %r(\/about\/(.*)),  'https://www.simband.io/documentation/about/$1'
  r301   %r(.*),  'https://www.simband.io/'
end

use Rack::Cors do
  allow do
    origins '*'
    resource '*', :headers => :any, :methods => [:get, :post, :options]
  end
end

# Serve static files under a `build` directory:
# - `/` will try to serve your `build/index.html` file
# - `/foo` will try to serve `build/foo` or `build/foo.html` in that order
# - missing files will try to serve build/404.html or a tiny default 404 page

module Rack
  class TryStatic
    def initialize(app, options)
      @app = app
      @try = ['', *options.delete(:try)]
      @static = ::Rack::Static.new(lambda { [404, {}, []] }, options)
    end

    def call(env)
      orig_path = env['PATH_INFO']
      found = nil
      
      @try.each do |path|
        resp = @static.call(env.merge!({'PATH_INFO' => orig_path + path}))
        break if 404 != resp[0] && found = resp
      end

      found or @app.call(env.merge!('PATH_INFO' => orig_path))
    end
  end
end

use Rack::Deflater
use Rack::TryStatic, :root => "build", :urls => %w[/], :try => ['.html', 'index.html', '/index.html']

# Run your own Rack app here or use this one to serve 404 messages:
run lambda{ |env|
  not_found_page = File.expand_path("../build/404.html", __FILE__)
  if File.exist?(not_found_page)
    [ 404, { 'Content-Type'  => 'text/html'}, [File.read(not_found_page)] ]
  else
    [ 404, { 'Content-Type'  => 'text/html' }, ['404 - page not found'] ]
  end
}
