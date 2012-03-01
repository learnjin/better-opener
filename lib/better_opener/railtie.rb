module BetterOpener
  class Railtie < Rails::Railtie
    initializer "better_opener.add_delivery_method" do
      ActionMailer::Base.add_delivery_method :better_opener, BetterOpener::DeliveryMethod
    end
  end
end

