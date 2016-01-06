class User < ActiveRecord::Base
  has_one :session, dependent: :destroy

  attr_accessor :password, :password_confirmation

  validates :email, uniqueness: { case_sensitive: false, message: "This email address is already registered." },
                    format: { with: /.*\@.*\..*/, message: "is incorrect"},
                    presence: true

  validates_presence_of :first_name, :last_name, :user_name

  validates :password, presence: true, confirmation: true, length: { in: 8..20 }, if: lambda { new_record? || password }

  validates :gender, inclusion: { in: ['male', 'female'], message: 'can be only male/female'}, presence: true

  validates_uniqueness_of :user_name

  before_save :encrypt_password

  has_attached_file :avatar, styles: { thumb: '200x200#' }, default_url: '/assets/avatar.png', default_style: :thumb

  validates_attachment :avatar, content_type: { content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif', 'application/octet-stream'] }

  has_many :services

  DISTANCE_IN_RADIUS     = 0.09144 # 100 yards in kilometers
  DISTANCE_OUT_OF_RADIUS = 8.047   # 5 miles in kilometers

  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode

  before_save :update_location_timestamp

  has_many :initiated_conversations, class_name: Conversation, foreign_key: :initiator_id
  has_many :supported_conversations, class_name: Conversation, foreign_key: :opponent_id

  def conversations
    Conversation.where(['initiator_id = :id OR opponent_id = :id', id: self.id])
  end

  def unread_messages
    Message.where(opponent_id: self.id, viewed: false)
  end

  def unread_messages_count
    unread_messages.count
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
    self.update_attributes latitude: lat.to_s.gsub(',', '.'),
                           longitude: lng.to_s.gsub(',', '.'),
                           location_updated_at: Time.now
    back_in_radius
  end

  def reset_location
    self.update_attributes latitude: nil, longitude: nil
    back_in_radius
  end

  def back_in_radius
    all_conversations_users_ids = self.conversations.active.pluck(:initiator_id, :opponent_id).flatten - [self.id]

    in_radius_and_in_conversation_users_ids = User.near([self.latitude, self.longitude], User::DISTANCE_IN_RADIUS)
                                                  .where(id: all_conversations_users_ids)
                                                  .where.not(latitude: nil, longitude: nil)
                                                  .map(&:id)

    new_in_radius = self.conversations
                        .active
                        .out_of_radius
                        .where(['initiator_id IN(:self) AND opponent_id IN(:ids) OR initiator_id IN(:ids) AND opponent_id IN(:self)', self: self.id,  ids: in_radius_and_in_conversation_users_ids])
                        .distinct

    users_without_location = User.where(latitude: nil, longitude: nil).pluck(:id)

    out_radius_and_in_conversation_users_ids = User.where(id: (all_conversations_users_ids - in_radius_and_in_conversation_users_ids) - users_without_location).map(&:id)

    new_out_of_radius = self.conversations
                            .active
                            .in_radius
                            .where(['initiator_id IN(:self) AND opponent_id IN(:ids) OR initiator_id IN(:ids) AND opponent_id IN(:self)', self: self.id,  ids: out_radius_and_in_conversation_users_ids])
                            .distinct

    new_out_of_radius.update_all(in_radius: false)

    new_in_radius.each do |conversation|
      conversation.update_attribute(:in_radius, true)
      if conversation.messages.first.created_at < Time.now - 25.seconds	
        user = User.find_by(id: [conversation.initiator_id, conversation.opponent_id] - [self.id])

        self.send_push_notification(message: "#{user.user_name} is back in radius", back_in_radius: true)
        user.send_push_notification(message: "#{self.user_name} is back in radius", back_in_radius: true)
      end
    end
  end

  def send_push_notification(message:, back_in_radius: false)
    return unless message

    if session && session.device && session.device_token

      if session.device.downcase == 'ios'
        begin
          notification = Grocer::Notification.new(
              device_token: session.device_token,
              alert:        message,
              sound:        "default",
              badge:        unread_messages_count,
              custom:       { back_in_radius: back_in_radius }
          )
          $ios_pusher.push(notification)
        rescue Exception => e

        end
      elsif session.device.downcase == 'android'
        begin
          url = 'https://android.googleapis.com/gcm/send'
          headers = {
              'Authorization' => 'key=AIzaSyCjfRxYHdy6G0IuIUFeAR5sR2f5jjytKwI',
              'Content-Type'  => 'application/json'
          }
          request = {
              'registration_ids' => [session.device_token],
              data: {
                  'title' => 'IceBr8kr',
                  'message' => message,
                  'back_in_radius' => back_in_radius
              }
          }
          RestClient.post(url, request.to_json, headers)
        rescue Exception => e

        end

      end
    end
  end

  def in_radius?(opponent)
    User.near([self.latitude, self.longitude], User::DISTANCE_IN_RADIUS).where(id: opponent.id).present?
  end

  def self.search(latitude:, longitude:, distance: , except_ids: , current_user:)
    User.near([latitude, longitude], distance).
        select('conversation.updated_at AS conversation_updated_at').
        joins( <<SQL
        LEFT JOIN (SELECT initiator_id, opponent_id, updated_at FROM conversations ORDER BY conversations.updated_at) conversation
        ON conversation.initiator_id IN (users.id, #{ current_user.id }) AND conversation.opponent_id IN ( #{ current_user.id }, users.id )
SQL
        ).
        where.not(id: except_ids).
        group('users.id').
        reorder('conversation.updated_at DESC, users.user_name ASC')
  end

  def sended_messages_count_to(user)
    Message.where(author_id: self.id, opponent_id: user.id).count
  end

  def received_messages_count_from(user)
    Message.where(author_id: user.id, opponent_id: self.id).count
  end

  def set_random_password
    self.password = self.password_confirmation = generate_random_string
  end

  private

  def update_location_timestamp
    self.location_updated_at = Time.now if self.latitude_changed? || self.longitude_changed?
  end

  def generate_random_string
    (0...19).map { (('a'..'z').to_a + ('A'..'Z').to_a).to_a[rand(52)] }.join
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
