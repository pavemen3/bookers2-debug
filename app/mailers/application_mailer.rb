class ApplicationMailer < ActionMailer::Base
  default from: "bookers2管理人<#{ENV['MAIL_USER_NAME']}>"
  layout 'mailer'
end
