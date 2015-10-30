require 'rails_helper'

describe User do

  let(:user) { create :user }

  describe '#conversations' do
    it 'should return all my conversations' do
      create :conversation, { initiator_id: user.id }
      create :conversation, { opponent_id: user.id }
      create :conversation

      expect(user.conversations.count).to eq(2)
    end
  end

  describe '#unread_messages' do
    let(:initiator) { create :user, longitude: 42.1234, latitude: 23.5432 }
    let(:opponent) { create :user, longitude: 42.1234, latitude: 23.5432 }

    it 'should return all not viewed replies to my messages' do
      conversation = create :conversation, { initiator_id: initiator.id, opponent_id: opponent.id }
      create :message, { viewed: true, author_id: initiator.id, conversation_id: conversation.id }
      create :message, { viewed: false, author_id: opponent.id , conversation_id: conversation.id }

      expect(initiator.unread_messages.count).to eq(1)
    end
  end

  describe '#authenticate' do
    it 'should authenticate if password match' do
      expect(user.authenticate(user.password)).to be_truthy
    end

    it 'should not authenticate if password is wrong' do
      expect(user.authenticate('wrongpassword')).to be_falsey
    end
  end


  describe '#send_reset_password_instructions' do
    it 'should create new password' do
      old_password = user.reset_password_token
      user.send_reset_password_instructions path: '/passwords/edit'

      expect(user.reset_password_token).to_not eq(old_password)
    end

    it 'should send email with new password' do
      expect{user.send_reset_password_instructions path: '/passwords/edit'}.to change{ ActionMailer::Base.deliveries.count }.by(1)
    end
  end

  describe '#send_feedback' do
    let(:mail) {UserMailer.feedback(user, 'Good Feedback')}

    it 'should send a good feedback' do
      expect(mail.body.encoded).to match('Good Feedback')
    end
  end

  describe '#set_location' do
    it 'should set new location to user' do
      expect{user.set_location('22.12345', '52.54321')}.to change{ user.attributes }
    end
  end

  describe '#reset_location' do
    it 'should reset users location' do
      user.set_location('22.12345', '52.54321')
      expect{user.reset_location}.to change{ user.attributes }
    end
  end

end