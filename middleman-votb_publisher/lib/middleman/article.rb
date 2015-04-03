require 'pathname'

module Middleman
  module VOTBPublisher
    module VOTBArticle
      def self.extended(base)
        base.class.send(:attr_accessor, :votb_controller)
      end

      def votb_options
        votb_controller.options
      end

      def render(opts={}, locs={}, &block)
        opts.merge! :layout => false
        content = super(opts, locs, &block)
        content.gsub!('href="/', "href=\"#{votb_options.site_domain.chomp('/')}/")
        if votb_options.relative_assets
          path = Pathname.new(self.path)
          dir = File.dirname(path)
          content.gsub!('src="..', "src=\"#{votb_options.site_domain.chomp('/')}/#{dir}/../..")
        else
          content.gsub!('src="/', "src=\"#{votb_options.site_domain.chomp('/')}/")
        end

        content
      end

    end
  end
end

