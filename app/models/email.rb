class Email < ActiveRecord::Base
  include Authentication

  named_scope :confirmed, :conditions => { :confirmed => true }

  belongs_to :user
  has_many :viewships, :as => :viewable
  
  validates_length_of :email, :within => 6..100
  validates_presence_of :email
  validates_uniqueness_of :email, :case_sensitive => false, :if => :confirmed?
  validates_format_of :email, :with => RE_EMAIL_OK, :message => MSG_EMAIL_BAD, :allow_nil => true
    
  is_gravtastic :email, :size => 40

  attr_accessor :pending_claim_by

  def claim!(claimed_user)  
    self.update_attributes({ :user_id   => claimed_user.id,
                             :email     => claimed_user.email,
                             :confirmed => true })
  end
  
  after_create :create_claim_code
  def create_claim_code
    self.claim_code = "test"
  end

  after_create :send_activation_email
  def send_activation_email
    Mailer.deliver_email_activation(self, self.pending_claim_by)
  end
  
  def username
    self.email.split("@").first + "..."
  end
end