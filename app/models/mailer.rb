class Mailer < ActionMailer::Base  
  def email_activation(email, user)
    setup_email(user, email.email)
    @subject << 'Confirm your email address'
    @body[:url] = "#{APP_CONFIG[:site_url]}/emails/#{email.claim_code}"
    @body[:email] = email
    @body[:user] = user
  end
  
  protected
  
  def setup_email(user, email)
    @recipients = "#{email}"
    @from = APP_CONFIG[:admin_email]
    @subject = "[#{APP_CONFIG[:site_name]}] "
    @sent_on = Time.now
  end
end
