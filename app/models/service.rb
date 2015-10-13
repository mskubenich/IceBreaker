class Service < ActiveRecord::Base
  belongs_to :user

  validates :uid, presence: true

  scope :facebook, -> { where provider: :facebook }
end
