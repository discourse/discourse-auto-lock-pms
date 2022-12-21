# frozen_string_literal: true

require "rails_helper"

describe Topic do
  before do
    SiteSetting.discourse_announcement_pm_enabled = true
  end

  let(:user) { Fabricate(:user) }

  context 'when a private message is created' do
    it 'should have the is_announcement_pm custom field' do
      pm = Fabricate(:private_message_topic, user: user)
      expect(pm.custom_fields['is_announcement_pm']).to eq(nil)
    end

    it 'should set the topic to closed if is_announcement_pm custom field is true' do
      pm = Fabricate(:private_message_topic, user: user)
      TopicCustomField.create!(topic_id: pm.id, name: "is_announcement_pm", value: true)
      put "/t/#{pm.id}.json", params: { is_announcement_pm: true }
      expect(pm.custom_fields['is_announcement_pm']).to eq(true)
      expect(pm.closed).to eq(true)
    end
  end
end
