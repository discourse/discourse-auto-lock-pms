import { apiInitializer } from "discourse/lib/api";

export default apiInitializer((api) => {
  api.serializeOnCreate("auto_lock_pm");
  api.serializeToDraft("auto_lock_pm");
});
