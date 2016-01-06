require 'rails_helper'
include SessionsHelper

describe Api::V1::SearchController, type: :controller do
  render_views

  describe "#index" do
    it 'should be logged in before using search' do
      get :index, format: :json

      expect(response.status).to eq(401)
      result = JSON.parse(response.body)

      expect(result).to eq({"errors" => ["Access denied."]})
    end

    it 'should return error if location is not set' do
      user = create :user
      session = sign_in user

      get :index, format: :json, session_token: session.token

      expect(response.status).to eq(422)
      result = JSON.parse(response.body)

      expect(result).to eq({"errors" => ["You should to set up your location before use search."]})
    end

    it 'should render users list ordered by last activity' do
      current_user = create :user
      current_user.set_location(0, 0)
      5.times do |i|
        user = create :user, user_name: "user_#{ i }"
        user.set_location(0, 0)
        Timecop.travel(Time.new(2002, i + 1, i + 1, 2, 2, 2, "+02:00")) do
          create :conversation, initiator_id: current_user.id, opponent_id: user.id
        end
      end

      5.times do |i|
        user = create :user, user_name: "user_#{ i + 5 }"
        user.set_location(0, 0)
        Timecop.travel(Time.new(2002, i + 1, i + 1, 2, 2, 2, "+02:00")) do
          create :conversation, initiator_id: current_user.id, opponent_id: user.id
        end
      end

      session = sign_in current_user

      get :index, format: :json, session_token: session.token

      result = JSON.parse(response.body)

      expect(result['users_in_radius'][0]['user_name']).to eq('user_4')
      expect(result['users_in_radius'][1]['user_name']).to eq('user_9')
      expect(result['users_in_radius'][2]['user_name']).to eq('user_3')
      expect(result['users_in_radius'][3]['user_name']).to eq('user_8')
      expect(result['users_in_radius'][4]['user_name']).to eq('user_2')
      expect(result['users_in_radius'][5]['user_name']).to eq('user_7')
      expect(result['users_in_radius'][6]['user_name']).to eq('user_1')
      expect(result['users_in_radius'][7]['user_name']).to eq('user_6')
      expect(result['users_in_radius'][8]['user_name']).to eq('user_0')
      expect(result['users_in_radius'][9]['user_name']).to eq('user_5')
      expect(result['users_in_radius'][0]['last_activity']).to eq("05/05/2002 00:02")
      expect(result['users_in_radius'][1]['last_activity']).to eq("05/05/2002 00:02")
      expect(result['users_in_radius'][2]['last_activity']).to eq("04/04/2002 00:02")
      expect(result['users_in_radius'][3]['last_activity']).to eq("04/04/2002 00:02")
      expect(result['users_in_radius'][4]['last_activity']).to eq("03/03/2002 00:02")
      expect(result['users_in_radius'][5]['last_activity']).to eq("03/03/2002 00:02")
      expect(result['users_in_radius'][6]['last_activity']).to eq("02/02/2002 00:02")
      expect(result['users_in_radius'][7]['last_activity']).to eq("02/02/2002 00:02")
      expect(result['users_in_radius'][8]['last_activity']).to eq("01/01/2002 00:02")
      expect(result['users_in_radius'][9]['last_activity']).to eq("01/01/2002 00:02")
    end
  end
end