import { apiInitializer } from "discourse/lib/api";

export default apiInitializer("0.11.1", (api) => {
  api.serializeOnCreate("auto_lock_pm");
  api.serializeToDraft("auto_lock_pm");
});
