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

  before_save :update_location_timestamp

  DISTANCE_IN_RADIUS     = 0.09144 # 100 yards in kilometers
  DISTANCE_OUT_OF_RADIUS = 8.047   # 5 miles in kilometers

  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode

  has_many :initiated_conversations, class_name: Conversation, foreign_key: :initiator_id
  has_many :supported_conversations, class_name: Conversation, foreign_key: :opponent_id

  def conversations
    Conversation.where(['initiator_id = :id OR opponent_id = :id', id: self.id])
  end

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

  def send_feedback(message)
    UserMailer.feedback(self, message).deliver
  end

  def set_location(lat, lng)
    self.update_attributes(latitude: lat.gsub(',', '.'), longitude: lng.gsub(',', '.'))
  end

  def reset_location
    self.update_attributes! latitude: nil, longitude: nil
  end

  def back_in_radius
    all_conversations_users_ids = self.conversations.active.unfinished.pluck(:initiator_id, :opponent_id).flatten - [self.id]

    in_radius_and_in_conversation_users_ids = User.near([self.latitude, self.longitude], User::DISTANCE_IN_RADIUS).where(id: all_conversations_users_ids).where.not(latitude: nil, longitude: nil).map(&:id)
    new_in_radius = self.conversations.active.unfinished.out_of_radius.where(['initiator_id IN(:self) AND opponent_id IN(:ids) OR initiator_id IN(:ids) AND opponent_id IN(:self)', self: self.id,  ids: in_radius_and_in_conversation_users_ids]).distinct
    users_without_location = User.where(latitude: nil, longitude: nil).pluck(:id)
    out_radius_and_in_conversation_users_ids = User.where(id: (all_conversations_users_ids - in_radius_and_in_conversation_users_ids) - users_without_location).map(&:id)
    new_out_of_radius = self.conversations.active.unfinished.in_radius.where(['initiator_id IN(:self) AND opponent_id IN(:ids) OR initiator_id IN(:ids) AND opponent_id IN(:self)', self: self.id,  ids: out_radius_and_in_conversation_users_ids]).distinct

    new_out_of_radius.update_all(in_radius: false)

    new_in_radius.each do |conversation|
      conversation.update_attribute(:in_radius, true)
      user = User.find_by(id: [conversation.initiator_id, conversation.opponent_id] - [self.id])
      User.send_push_notification(user_id: self.id, message: "#{user.user_name} is back in radius", back_in_radius: true)
      User.send_push_notification(user_id: user.id, message: "#{self.user_name} is back in radius", back_in_radius: true)
    end
  end


  class << self
    def send_push_notification(options = {})
      user    = User.find options[:user_id]
      message = options[:message] ? options[:message] : "You have been ignored!"
      result  = false
      info    = 'Something went wrong'

      user.sessions.each do |session|
        if session.device && session.device_token

          if session.device.downcase == 'ios'
            notification = Grocer::Notification.new(
                device_token: session.device_token,
                alert:        message,
                sound:        "default",
                badge:        Conversation.unread_messages(options[:user_id]),
                custom: {back_in_radius: options[:back_in_radius] ? true : false}
            )
            $ios_pusher.push(notification)
            result = true
            info = 'Pushed to IOS'
          elsif session.device.downcase == 'android'
            require 'rest_client'
            url = 'https://android.googleapis.com/gcm/send'
            headers = {
                'Authorization' => 'key=AIzaSyBCK9NX8gRY51g9UwtY1znEirJuZqTNmAU',
                'Content-Type'  => 'application/json'
            }
            request = {
                'registration_ids' => [session.device_token],
                data: {
                    'title' => 'IceBr8kr',
                    'message' => message,
                    'back_in_radius' => options[:back_in_radius] ? true : false
                }
            }

            response = RestClient.post(url, request.to_json, headers)
            result = true
            info = 'Pushed to Android'
          end
        end
      end
    end
  end

  private

  def update_location_timestamp
    self.location_updated_at = Time.now if self.latitude_changed? || self.longitude_changed?
  end

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
