class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :first_name, :last_name, :mobile_no, :tel_no, :fax_no,
                  :address, :country_id, :role

  has_many :poi_user_privileges
  has_many :pois, :through => :poi_user_privileges
  belongs_to :country

  #validates :password, :presence => true
  #validates :password_confirmation, :presence => true

  validates :first_name, :last_name, :presence => true, :if => :partner?
  validates :mobile_no, :presence => true, :numericality => true, :if => :partner?
  validates :address, :country_id, :presence => true, :if => :partner?

  validates_confirmation_of :password

  scope :latest, :order => "created_at DESC"

  def partner?
    return self.role == "partner"
  end

  def admin?
    return self.role == "admin"
  end

  def belongs_to_role?(role_array)
    return role_array.include? "#{self.role}"
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end
end
