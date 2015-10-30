require 'rails_helper'

describe Message do

  let(:opponent) { create :user, latitude: 22.12345, longitude: 41.12345 }
  let(:initiator) { create :user, latitude: 22.12345, longitude: 41.12345 }
  let(:conversation) { create :conversation, initiator_id: initiator.id, opponent_id: opponent.id }

  describe '#validate' do
    it 'should return error if conversation is muted' do
      create :message, author_id: initiator.id, conversation_id: conversation.id
      create :message, author_id: opponent.id, conversation_id: conversation.id
      create :message, author_id: initiator.id, conversation_id: conversation.id

      expect{create :message, author_id: initiator.id, conversation_id: conversation.id}.to raise_error
    end

    it 'should return error if conversation is done' do
      create :message, author_id: initiator.id, conversation_id: conversation.id
      create :message, author_id: opponent.id, conversation_id: conversation.id
      create :message, author_id: initiator.id, conversation_id: conversation.id

      Timecop.freeze(DateTime.now + 5.hours) do
        expect{create :message, author_id: initiator.id, conversation_id: conversation.id}.to raise_error
      end
    end

    it 'should return error if users out of radius' do
      init = create :user, latitude: 22.12345, longitude: 41.12345
      opp = create :user, latitude: 2.12345, longitude: 15.12345

      expect{create :message, author_id: init.id, conversation_id: opp.id}.to raise_error
    end
  end

end
