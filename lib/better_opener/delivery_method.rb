module BetterOpener
  class DeliveryMethod

    def initialize(options = {})
    end

    def deliver!(mail)
      BetterOpener.add_notification("email", mail.subject, BetterOpener.render_email('NAME', mail))
    end
  end

end

