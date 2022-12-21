export default {
  shouldRender(args) {
    if (
      args.model.siteSettings.discourse_auto_lock_pms_enabled &&
      args.model.action === "privateMessage"
    ) {
      return true;
    }
    return false;
  },
};
