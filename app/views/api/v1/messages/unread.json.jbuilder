json.messages @messages do |message|
  json.conversation_id message.conversation_id
  json.text message.text
  json.author_id message.author_id
end