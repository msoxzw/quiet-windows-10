// Mozilla Preferences

defaultPref("accessibility.force_disabled", 1);
defaultPref("app.normandy.enabled", false);
defaultPref("browser.cache.disk.enable", false);
defaultPref("browser.cache.memory.capacity", getPref("browser.cache.disk.capacity"));
defaultPref("browser.cache.memory.max_entry_size", getPref("browser.cache.disk.max_entry_size"));
defaultPref("browser.cache.offline.enable", false);
pref("browser.contentblocking.category", "strict");
defaultPref("browser.formfill.enable", false);
defaultPref("browser.newtabpage.activity-stream.feeds.snippets", false);
defaultPref("browser.region.network.url", "");
defaultPref("browser.safebrowsing.downloads.remote.enabled", false);
clearPref("browser.search.region");
defaultPref("browser.search.suggest.enabled", false);
defaultPref("browser.sessionstore.privacy_level", 2);
defaultPref("browser.sessionstore.resume_from_crash", false);
defaultPref("browser.shell.checkDefaultBrowser", false);
defaultPref("browser.slowStartup.notificationDisabled", true);
defaultPref("browser.startup.homepage", "https://www.wikipedia.org/");
pref("browser.startup.homepage_override.mstone", "ignore");
defaultPref("browser.tabs.crashReporting.sendReport", false);
defaultPref("browser.urlbar.speculativeConnect.enabled", false);
defaultPref("datareporting.healthreport.uploadEnabled", false);
defaultPref("datareporting.policy.dataSubmissionEnabled", false);
defaultPref("extensions.getAddons.cache.enabled", false);
defaultPref("extensions.systemAddon.update.enabled", false);
defaultPref("identity.fxaccounts.enabled", false);
defaultPref("media.gmp-manager.updateEnabled", false);
defaultPref("media.peerconnection.ice.relay_only", true);
defaultPref("network.captive-portal-service.enabled", false);
defaultPref("network.cookie.lifetimePolicy", 2);
defaultPref("network.http.referer.defaultPolicy", getPref("network.http.referer.defaultPolicy.pbmode"));
defaultPref("network.trr.disable-ECS", false);
defaultPref("network.trr.mode", 2);
defaultPref("network.trr.uri", "https://dns.nextdns.io/");
defaultPref("places.history.enabled", false);
defaultPref("privacy.firstparty.isolate", true);
defaultPref("privacy.resistFingerprinting", true);
defaultPref("security.OCSP.enabled", 2);
defaultPref("toolkit.telemetry.unified", false);
defaultPref("webgl.enable-debug-renderer-info", false);