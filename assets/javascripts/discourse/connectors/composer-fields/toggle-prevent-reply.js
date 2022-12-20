export default {
  shouldRender(args) {
    if (
      args.model.siteSettings.discourse_announcement_pm_enabled &&
      args.model.action === "privateMessage"
    ) {
      return true;
    }
    return false;
  },
};
