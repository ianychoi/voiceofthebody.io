# Require core library
require 'middleman-core'
require 'middleman/extension'
require 'middleman/articles'
require 'middleman/article'
::Middleman::Extensions.register(:votb_publisher, ::Middleman::VOTBPublisher::Extension )
