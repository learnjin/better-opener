BetterOpener
=============

Preview mails and other notifications in your browser instead of actually
sending them out. Inspired by and similar in terms of functionality to the
[LetterOpener][1] and the [MailView][2] gem BetterOpener tries to be *better*
by:

- providing support for outgoing notifications in general (email, sms so far)
- supporting pre- and on-demand rendering
- allowing remote access to notifications (helpful on staging servers and remote development machines)
- displaying desktop notifications (with the accompanying chrome plugin)


Setup
-----

Add the gem to your development environment and run the `bundle install` command to install it.

    gem "better_opener", :group => :development

Then in Rails3 mount the bundled Sinatra app inline in your `routes.rb`:

    if Rails.env == "development"
      mount BetterOpener::Server => "/notifications"
    end

To make messages actually being sent to `/notifications` set up email and/or sms interception.

### Email

Set the delivery method in `config/environments/development.rb`

    config.action_mailer.delivery_method = :better_opener

The design of the email interface is taken from the [mail_view][2] plugin.


### SMS

SMS message support is provided for the [sms_gateway][3] gem.
Edit your `sms_gateway.yml` file:

    development:
      adapter: better_opener
      from: your_app

SMS interface:

![SMS as displayed by the sinatra app](https://github.com/learnjin/better-opener/raw/master/sms.jpg)


On-request Rendering
-------------------

The messages that are being sent with one of the above delivery methods are
static (pre-rendered at time of delivery). To preview your changes without
going through all the steps to redeliver the message use the
`add_delayed_notification` method like that:

    def self.deliver_later(method, *params)
      if Rails.env == "development"
        BetterOpener.add_delayed_notification("email", Emailer, method, params)
       else
         Resque.enqueue(EmailJob, method, *params)
       end
    end


Chrome Plugin
-------------

To get actual desktop notifications, you will want to install the accompanying
[chrome-plugin][4].  Point it to the (full) notification path that you mounted
this gem on.

![Chrome Notifications](https://github.com/learnjin/better-opener/raw/master/notifications.png)

[1]: https://github.com/ryanb/letter_opener
[2]: https://github.com/37signals/mail_view
[3]: https://github.com/learnjin/sms-gateway 
[4]: https://github.com/learnjin/better-opener-chrome


