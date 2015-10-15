class Conversation < ActiveRecord::Base
  has_many :messages

  scope :unfinished,    ->  { where('(SELECT id FROM messages WHERE messages.conversation_id = conversations.id) = 3') }
  scope :active,        ->  { where(created_at: Time.zone.now - 1.months..Time.zone.now) }
  scope :out_of_radius, ->  { where(in_radius: false) }
  scope :in_radius,     ->  { where(in_radius: true) }
end