import { apiInitializer } from "discourse/lib/api";

export default apiInitializer("0.11.1", (api) => {
  api.serializeOnCreate("is_announcement_pm");
  api.serializeToDraft("is_announcement_pm");
  api.serializeToTopic("is_announcement_pm", "topic.is_announcement_pm");
});
