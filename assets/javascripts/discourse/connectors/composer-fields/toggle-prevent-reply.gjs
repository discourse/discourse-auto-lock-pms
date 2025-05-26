import Component, { Input } from "@ember/component";
import { classNames, tagName } from "@ember-decorators/component";
import { i18n } from "discourse-i18n";

@tagName("div")
@classNames("composer-fields-outlet", "toggle-prevent-reply")
export default class TogglePreventReply extends Component {
  static shouldRender(args) {
    if (
      args.model.siteSettings.discourse_auto_lock_pms_enabled &&
      args.model.action === "privateMessage"
    ) {
      return true;
    }
    return false;
  }

  <template>
    <Input @type="checkbox" @checked={{mut this.model.auto_lock_pm}} />
    {{i18n "discourse_auto_lock_pms.composer_toggle_label"}}
  </template>
}
