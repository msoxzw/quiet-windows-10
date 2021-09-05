// Mozilla Preferences

defaultPref("browser.cache.disk.enable", false);
defaultPref("browser.cache.memory.capacity", getPref("browser.cache.disk.capacity"));
defaultPref("browser.cache.memory.max_entry_size", getPref("browser.cache.disk.max_entry_size"));
defaultPref("browser.formfill.enable", false);
defaultPref("browser.region.network.url", "");
clearPref("browser.search.region");
defaultPref("datareporting.healthreport.uploadEnabled", false);
defaultPref("datareporting.policy.dataSubmissionEnabled", false);
defaultPref("extensions.getAddons.cache.enabled", false);
defaultPref("extensions.systemAddon.update.enabled", false);
defaultPref("mail.minimizeToTray", true);
defaultPref("mail.provider.enabled", false);
defaultPref("mail.sanitize_date_header", true);
defaultPref("mail.suppress_content_language", true);
defaultPref("mail.shell.checkDefaultClient", false);
defaultPref("mail.winsearch.firstRunDone", true);
defaultPref("mailnews.start_page.enabled", false);
pref("mailnews.start_page_override.mstone", "ignore");
defaultPref("media.peerconnection.ice.relay_only", true);
defaultPref("network.captive-portal-service.enabled", false);
defaultPref("network.connectivity-service.enabled", false);
defaultPref("network.cookie.lifetimePolicy", 2);
defaultPref("places.history.enabled", false);
defaultPref("toolkit.telemetry.unified", false);
