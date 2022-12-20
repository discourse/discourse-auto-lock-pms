# frozen_string_literal: true

# name: discourse-announcement-pm
# about: Send a PM with restricted replies
# version: 0.0.1
# authors: Discourse
# url: https://github.com/discourse/discourse-announcement-pm
# required_version: 2.7.0

register_asset "stylesheets/common/common.scss"

enabled_site_setting :discourse_announcement_pm_enabled

after_initialize do
  IS_ANNOUNCEMENT_FIELD = {
    name: "is_announcement_pm",
    type: "boolean",
  }

  register_topic_custom_field_type(IS_ANNOUNCEMENT_FIELD[:name], IS_ANNOUNCEMENT_FIELD[:type].to_sym)

  # Getter Method
  add_to_class(:topic, IS_ANNOUNCEMENT_FIELD[:name].to_sym) do
    if !custom_fields[IS_ANNOUNCEMENT_FIELD[:name]].nil?
      custom_fields[IS_ANNOUNCEMENT_FIELD[:name]]
    else
      nil
    end
  end

  # Setter Method
  add_to_class(:topic, "#{IS_ANNOUNCEMENT_FIELD[:name]}=") do |value|
    custom_fields[IS_ANNOUNCEMENT_FIELD[:name]] = value
  end

  # Update on Topic Creation
  on(:topic_created) do |topic, opts, user|
    if opts[:archetype] == "private_message"
      topic.send("#{IS_ANNOUNCEMENT_FIELD[:name]}=".to_sym, opts[IS_ANNOUNCEMENT_FIELD[:name].to_sym])
      topic.save!

      # Close the topic if it's an announcement
      if opts[:is_announcement_pm]
        topic.closed = true
        topic.save!
      end
    end
  end

  # Update on Topic Edit
  PostRevisor.track_topic_field(IS_ANNOUNCEMENT_FIELD[:name].to_sym) do |tc, value|
    tc.record_change(IS_ANNOUNCEMENT_FIELD[:name], tc.topic.send(IS_ANNOUNCEMENT_FIELD[:name]), value)
    tc.topic.send("#{IS_ANNOUNCEMENT_FIELD[:name]}=".to_sym, value.present? ? value : nil)
  end

  # Serialize to Topic
  add_to_serializer(:topic_view, IS_ANNOUNCEMENT_FIELD[:name].to_sym) do
    object.topic.send(IS_ANNOUNCEMENT_FIELD[:name])
  end

  # Preload the Field
  add_preloaded_topic_list_custom_field(IS_ANNOUNCEMENT_FIELD[:name])

  # Serialize to the topic list
  add_to_serializer(:topic_list_item, IS_ANNOUNCEMENT_FIELD[:name].to_sym) do
    object.send(IS_ANNOUNCEMENT_FIELD[:name])
  end
end
