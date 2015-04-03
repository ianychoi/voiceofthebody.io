module Middleman
  module VOTBPublisher
    class Extension < Middleman::Extension
      delegate :logger, to: :app
      option :dir, 'publisher', 'directory to serve raw html from'
      option :site_domain, 'http://localhost:4567/', 'domain for fully qualified paths'
      option :relative_assets, false, 'prefix fully qualified assets with relative paths'
      attr_reader :sitemap

      def initialize(app, options_hash={}, &block)
        # Call super to build options from the options_hash
        super

      end

      def after_configuration
        # Do something
        @articles = Middleman::VOTBPublisher::VOTBArticles.new( @app, self )
        @app.sitemap.register_resource_list_manipulator(:"votb_publisher_pages", @articles, false)
      end

    end
  end
end

