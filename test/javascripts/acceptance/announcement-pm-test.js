import { acceptance, exists } from "discourse/tests/helpers/qunit-helpers";
import { test } from "qunit";
import { click, visit } from "@ember/test-helpers";
import pmTopicFixture from "../fixtures/pm-topic-fixture";

acceptance("Announcement PM Toggle", function (needs) {
  needs.user();
  needs.settings({
    discourse_auto_lock_pms_enabled: true,
  });

  needs.pretender((server, helper) => {
    server.get("/t/161.json", () => {
      return helper.response(pmTopicFixture);
    });
  });

  test("Toggle appears in PM composer", async function (assert) {
    await visit("/u/eviltrout/messages");
    await click(".new-private-message");
    assert.ok(exists(".toggle-prevent-reply"), "toggle exists");
  });

  test("Toggle does not appear in topic composer", async function (assert) {
    await visit("/");
    await click("#create-topic");
    assert.ok(!exists(".toggle-prevent-reply"), "toggle does not exist");
  });

  test("Toggle does not appear in PM reply composer", async function (assert) {
    await visit("/t/161");
    await click(".topic-footer-main-buttons .create");
    assert.ok(!exists(".toggle-prevent-reply"), "toggle does not exist");
  });
});
