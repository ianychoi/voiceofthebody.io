module Middleman
  module VOTBPublisher
    class VOTBArticles
      attr_reader :controller

      def initialize(app, controller)
        @sitemap = app.sitemap
        @controller = controller
        @publisher_dir = controller.options.dir
      end

      # A Sitemap Manipulator
      # def manipulate_resource_list(resources)
      # end
      def manipulate_resource_list(resources)
        new_resources = []
        resources.each do |resource|
          if resource.metadata[:page]["cors"] == true
            cors_resource = Sitemap::Resource.new(@sitemap, "#{@publisher_dir}/#{resource.path}", resource.source_file)
            cors_resource.extend VOTBArticle
            cors_resource.votb_controller = @controller
            new_resources << cors_resource
          end
        end
        # puts new_resources
        resources + new_resources
      end
    end
  end
end

