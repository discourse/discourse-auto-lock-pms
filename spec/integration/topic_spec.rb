# frozen_string_literal: true

require "rails_helper"

describe Topic do
  before { SiteSetting.discourse_auto_lock_pms_enabled = true }

  let(:admin) { Fabricate(:admin) }
  let(:user) { Fabricate(:user) }
  let(:basic_topic_params) do
    { title: "hello world topic", raw: "my name is fred", archetype: Archetype.private_message }
  end

  context "when a private message is created" do
    it "should have the auto_lock_pm custom field" do
      pm = Fabricate(:private_message_topic, user: user)
      expect(pm.custom_fields["auto_lock_pm"]).to eq(nil)
    end

    it "should set the topic to closed if auto_lock_pm custom field is true" do
      output =
        PostCreator.create(
          admin,
          basic_topic_params.merge(auto_lock_pm: true, target_usernames: [user.username]),
        )

      pm = Topic.last
      expect(pm.custom_fields["auto_lock_pm"]).to eq(true)
      expect(pm.closed).to eq(true)
    end
  end
end
