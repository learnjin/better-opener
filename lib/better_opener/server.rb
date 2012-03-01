require 'rubygems' if RUBY_VERSION < '1.9'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'haml'
require 'data_mapper'
require 'better_opener' 

module BetterOpener

  class Server < Sinatra::Base
    configure :development do
      register Sinatra::Reloader
    end

    helpers do
      include Rack::Utils
      alias_method :h, :escape_html

      def url_path(*path_parts)
        path = [ path_prefix, path_parts ].join("/").squeeze('/')
        request.scheme + "://" + request.host_with_port + path
      end
      alias_method :u, :url_path

      def path_prefix
        request.script_name
      end

    end

    dir = File.dirname(File.expand_path(__FILE__))

    set :views,  "#{dir}/server/views"
    set :public, "#{dir}/server/public"
    set :static, true

    get "/" do
      @messages = BetterOpener.get_all_notifications
      haml :index
    end

    get "/:id" do
      @message = BetterOpener.get_notification(params[:id])
      @message.body 
    end

    get "/feed/atom", :provides => [:atom] do
      @messages = BetterOpener.get_all_notifications
      content_type 'application/rss+xml'
      haml(:atom, :format => :xhtml, :escape_html => true, :layout => false)
    end

  end
end
