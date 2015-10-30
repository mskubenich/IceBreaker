require 'rails_helper'

describe Conversation do

  let(:initiator) { create :user, latitude: 22.12345, longitude: 41.12345  }
  let(:opponent) { create :user, latitude: 22.12345, longitude: 41.12345}
  let(:conversation) { create :conversation, initiator_id: initiator.id, opponent_id: opponent.id}

  describe 'Message Types:' do
    it 'should return messages with type initial' do
      initial_message = create :message, conversation_id: conversation.id, author_id: initiator.id

      expect(conversation.initial_message).to eq(initial_message)
    end

    it 'should return messages with type reply' do
      create :message, conversation_id: conversation.id, author_id: initiator.id
      reply_message = create :message, conversation_id: conversation.id, author_id: initiator.id

      expect(conversation.reply_message).to eq(reply_message)
    end

    it 'should return messages with type finished' do
      create :message, conversation_id: conversation.id, author_id: initiator.id
      create :message, conversation_id: conversation.id, author_id: initiator.id
      finished_message = create :message, conversation_id: conversation.id, author_id: initiator.id

      expect(conversation.finished_message).to eq(finished_message)
    end
  end

  describe '#between_users' do
    it 'should create conversation' do
      expect{Conversation.between_users(initiator: initiator, opponent: opponent)}.to change{Conversation.count}.by(1)
    end

    it 'should return last conversation' do
      last_conversation = create :conversation, initiator_id: initiator.id, opponent_id: opponent.id

      expect{Conversation.between_users(initiator: initiator, opponent: opponent)}.to_not change{Conversation.count}
      expect(Conversation.between_users(initiator: initiator, opponent: opponent)).to eq(last_conversation)
    end
  end

  describe 'Callback: ' do
    describe '#muted?' do
      it 'should return true or false' do
        create :message, conversation_id: conversation.id, author_id: initiator.id
        create :message, conversation_id: conversation.id, author_id: opponent.id
        create :message, conversation_id: conversation.id, author_id: initiator.id

        expect(conversation.muted?).to be_truthy

        Timecop.freeze(DateTime.now + 5.hours) do
          expect(conversation.muted?).to be_falsey
        end

      end
    end

    describe '#done?' do
      it 'should return true or false' do
        create :message, conversation_id: conversation.id, author_id: initiator.id
        create :message, conversation_id: conversation.id, author_id: opponent.id

        expect(conversation.done?).to be_falsey
        create :message, conversation_id: conversation.id, author_id: initiator.id
        expect(conversation.done?).to be_truthy
      end
    end
  end

  describe '#opponent_to' do
    it 'should return opponent' do
      expect(conversation.opponent_to(initiator)).to eq(opponent)
      expect(conversation.opponent_to(opponent)).to eq(initiator)
    end
  end

end