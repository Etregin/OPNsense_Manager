# ProGuard / R8 rules for OPNsense Manager

# Suppress missing class warnings for dependencies intentionally excluded on
# non-Play Store distribution flavors (github and fdroid).
# The plugin code (in_app_purchase_android, google_mobile_ads) is compiled by Flutter,
# but the underlying SDK AARs are stripped via configurations exclusion in build.gradle.kts.
-dontwarn com.android.billingclient.**
-dontwarn com.google.android.gms.ads.**
-dontwarn com.google.ads.mediation.**
