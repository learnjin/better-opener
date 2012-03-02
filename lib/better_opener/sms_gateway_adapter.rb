require 'sms_gateway'

module SmsGateway

  module Adapters
    class BetterOpener

      def initialize(config={})
        @config = {:from => SmsGateway::Base.from }
        @config.merge!(config)
      end

      def send_sms(sms)
        options = @config.merge({:to => sms.to, :message => sms.text })  
        ::BetterOpener.add_notification("sms", sms.from, ::BetterOpener.render_sms('sms', sms) )
      end

    end
  end
end


