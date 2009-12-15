class EmailController < ApplicationController
  before_filter :login_required
  before_filter :find_email_by_claim_code, :only => :show

  def show
    @email.confirm!(current_user)
  end
  
  private 
  def find_email_by_claim_code
    @email = Email.find_by_claim_code(params[:id])
  end
end