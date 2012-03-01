require "better_opener/version"

require 'data_mapper'
require 'time'
require 'tilt'
require 'rack/mime'

module BetterOpener

  class Notification
    include DataMapper::Resource
    property :id, Serial
    property :subject, String
    property :body, String
    property :created_at, DateTime 
    property :category, String
  end

  extend self

  def db=(server)
    @db = server
  end

  def db
    return @db if @db
    self.db = DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
    DataMapper.auto_upgrade!
    self.db
  end

  def get_all_notifications
    db && Notification.all(:order => [:id.desc])
  end

  def get_notification(id)
    db && Notification.get(id)
  end


  def add_notification(category, subject, body)
    db
    n = Notification.new :category => category, :subject => subject, :body => body, :created_at => Time.now
    n.save
  end

  def email_template_path
    File.expand_path('../better_opener/email.html.erb', __FILE__)
  end

  def email_template
    Tilt.new(email_template_path)
  end

  def render_email(name, mail, format = nil)
    body_part = mail

    if mail.multipart?
      content_type = Rack::Mime.mime_type(format)
      body_part = mail.parts.find { |part| part.content_type.match(content_type) } || mail.parts.first
    end

    email_template.render(Object.new, :name => name, :mail => mail, :body_part => body_part)
  end


end

require 'better_opener/delivery_method'
require 'better_opener/server'
require "better_opener/railtie" if defined? Rails


