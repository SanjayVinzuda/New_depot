class ErrorNotifier < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.error_notifier.notification.subject
  #
  def notification(error)
    @greeting = "Hi"

    @error = error
    mail :to => "sanjay.vinzuda@botreetechnologies.com", :subject => 'Depot App Error Incident'  ## replace your email id to receive mails
  end
end
