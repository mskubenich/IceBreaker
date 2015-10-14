class User < ActiveRecord::Base
  has_many :sessions, dependent: :destroy

  attr_accessor :password, :password_confirmation

  validates :email, uniqueness: { case_sensitive: false, message: "This email address is already registered." },
                    format: { with: /.*\@.*\..*/, message: "is incorrect"},
                    presence: true

  validates_presence_of :first_name, :last_name, :user_name

  validates :password, presence: true, confirmation: true, if: lambda { new_record? || password }, length: { in: 6..20 }

  validates :gender, inclusion: { in: ['male', 'female'], message: 'can be only male/female'}, presence: true

  validates_uniqueness_of :user_name

  before_save :encrypt_password

  has_attached_file :avatar, styles: { thumb: '200x200>' }, default_url: '/assets/avatar.png', default_style: :thumb

  validates_attachment :avatar, content_type: { content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif', 'application/octet-stream'] }

  has_many :services

  def authenticate(password)
    self.encrypted_password == encrypt(password)
  end

  def destroy
    super
  end

  def send_reset_password_instructions(options={})
    new_password = generate_random_string
    update_attributes reset_password_token: new_password
    UserMailer.forgot_password(self, new_password, path: options[:path]).deliver
  end

  private

  def generate_random_string
    (0...23).map { (('a'..'z').to_a + ('A'..'Z').to_a).to_a[rand(52)] }.join
  end

  def encrypt_password
    self.salt = make_salt if salt.blank?
    self.encrypted_password = encrypt(self.password) if self.password
  end

  def encrypt(string)
    secure_hash("#{string}--#{self.salt}")
  end

  def make_salt
    secure_hash("#{Time.now.utc}--#{self.password}")
  end

  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end
end
