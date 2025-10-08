# frozen_string_literal: true

# name: discourse-auto-lock-pms
# about: Adds a toggle to automatically lock PMs once they are sent
# version: 0.0.1
# authors: Discourse
# url: https://github.com/discourse/discourse-auto-lock-pms
# required_version: 2.7.0

register_asset "stylesheets/common/common.scss"

enabled_site_setting :discourse_auto_lock_pms_enabled

after_initialize do
  module ::DiscourseAutoLockPms
    AUTO_LOCK_FIELD = { name: "auto_lock_pm", type: "boolean" }
  end

  register_topic_custom_field_type(
    DiscourseAutoLockPms::AUTO_LOCK_FIELD[:name],
    DiscourseAutoLockPms::AUTO_LOCK_FIELD[:type].to_sym,
  )

  # Getter Method
  add_to_class(:topic, DiscourseAutoLockPms::AUTO_LOCK_FIELD[:name].to_sym) do
    if !custom_fields[DiscourseAutoLockPms::AUTO_LOCK_FIELD[:name]].nil?
      custom_fields[DiscourseAutoLockPms::AUTO_LOCK_FIELD[:name]]
    else
      nil
    end
  end

  # Setter Method
  add_to_class(:topic, "#{DiscourseAutoLockPms::AUTO_LOCK_FIELD[:name]}=") do |value|
    custom_fields[DiscourseAutoLockPms::AUTO_LOCK_FIELD[:name]] = value
  end

  # Update on Topic Creation
  on(:topic_created) do |topic, opts, user|
    if opts[:archetype] == "private_message"
      topic.send(
        "#{DiscourseAutoLockPms::AUTO_LOCK_FIELD[:name]}=".to_sym,
        opts[DiscourseAutoLockPms::AUTO_LOCK_FIELD[:name].to_sym],
      )
      topic.save!

      # Close the topic if auto_lock_pm is enabled
      if opts[:auto_lock_pm]
        topic.closed = true
        topic.save!
      end
    end
  end

  # Update on Topic Edit
  PostRevisor.track_topic_field(DiscourseAutoLockPms::AUTO_LOCK_FIELD[:name].to_sym) do |tc, value|
    tc.record_change(
      DiscourseAutoLockPms::AUTO_LOCK_FIELD[:name],
      tc.topic.send(DiscourseAutoLockPms::AUTO_LOCK_FIELD[:name]),
      value,
    )
    tc.topic.send("#{DiscourseAutoLockPms::AUTO_LOCK_FIELD[:name]}=".to_sym, (value.presence))
  end
end
