require "better_opener/version"

require 'data_mapper'
require 'time'
require 'tilt'
require 'rack/mime'

module BetterOpener

  class Notification
    include DataMapper::Resource
    property :id, Serial
    property :created_at, DateTime 
    property :subject, String, :length => 255
    property :summary, String

    property :category, String # influences rendering

    property :klass, String
    property :method, String
    property :params, String

    property :rendered, Boolean, :default => false
    property :body, Text
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
    db && BetterOpener::Notification.all(:order => [:id.desc])
  end

  def get_notification(id)
    db && BetterOpener::Notification.get(id)
  end


  def add_notification(category, subject, body)
    db
    n = BetterOpener::Notification.new(:category => category,
                                       :subject => subject,
                                       :body => body,
                                       :created_at => Time.now,
                                       :rendered => true)
    n.save
  end

  def add_delayed_notification(category, klass, method, params)
    db

    n = BetterOpener::Notification.new(:category => category,
                                       :subject => method,
                                       :klass => klass.name,
                                       :method => method,
                                       :params => BetterOpener.encode(params),
                                       :created_at => Time.now)
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


  def sms_template_path
    File.expand_path('../better_opener/sms.html.erb', __FILE__)
  end

  def sms_template
    Tilt.new(sms_template_path)
  end

  def render_sms(name, sms, format = nil)
    sms_template.render(Object.new, :name => name, :sms => sms)
  end


  def encode(params)
    MultiJson.encode(params)
  end

  def decode(params)
    MultiJson.decode(params)
  end

  def render_notification(n, format = nil)
    return n.body if n.rendered 
    klass = Kernel.const_get(n.klass.classify)
    if n.category == "email"
      m = klass.send(n.method, *BetterOpener.decode(n.params))
      BetterOpener.render_email(n.id, m, format)
    elsif n.category == "sms"
      m = klass.send(n.method, *BetterOpener.decode(n.params))
      BetterOpener.render_sms(n.id, m)
    end
  end


end

require 'better_opener/delivery_method'
require 'better_opener/server'
require "better_opener/railtie" if defined? Rails
require "better_opener/sms_gateway_adapter" if defined? SmsGateway


