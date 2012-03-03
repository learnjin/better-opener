BetterOpener
=============

Preview mails and other notifications, in your browser instead of actually
sending them out. Inspired by and similar in terms of functionality to the
[LetterOpener][1] and the [MailView][2] gem BetterOpener tries to be *better*
by:

- providing support for outgoing notifications in general (email, sms so far)
- allowing remote access to notifications (helpful on staging servers and remote development machines)
- displaying desktop notifications (with the accompanying chrome plugin)


Setup
-----

Add the gem to your development environment and run the <tt>bundle install</tt> command to install it.

    gem "better_opener", :group => :development

Then mount the bundled Sinatra app as a subdirectory of your app by editing <tt>config.ru</tt>:

    if Rails.env == "development"
      mount BetterOpener::Server => "/notifications"
    end

To make messages being sent to "/notifications" set up email and/or sms interception.

### Email

Set the delivery method in <tt>config/environments/development.rb</tt>

    config.action_mailer.delivery_method = :better_opener

The design of the email interface is taken from the [mail_view][2] plugin.


### SMS

SMS message support is provided for the [sms_gateway][3] gem.
Edit your <tt>sms_gateway.yml</tt> file:

    development:
      adapter: better_opener
      from: your_app

SMS interface:

![SMS as displayed by the sinatra app](https://github.com/learnjin/better-opener/raw/master/sms.jpg)


Chrome Plugin
-------------

To get actual desktop notifications, you will want to install the accompanying
[chrome-plugin][4].  Point it to the (full) notification path that you mounted
this gem on.


[1]: https://github.com/ryanb/letter_opener
[2]: https://github.com/37signals/mail_view
[3]: https://github.com/learnjin/sms-gateway 
[4]: https://github.com/learnjin/better-opener-chrome


