# Remove Dummy & Hardcoded Notifications Implementation Plan

Remove all hardcoded/dummy notification triggers from `NotificationApiService` and eliminate sample data fallbacks in `FcmService` so that the app relies exclusively on real, server-driven Firebase Cloud Messaging (FCM) notifications and valid backend property data.

## User Review Required

> [!IMPORTANT]
> - `NotificationApiService.notifyNewListing` currently makes an HTTP request to the backend AND directly triggers a local notification using hardcoded text (`New Property Listed! 🏠`). We will remove the local hardcoded fallback so notifications only arrive via true FCM push messages from the server.
> - `FcmService` currently falls back to `ToLetModel.sampleData` when a notification payload is tapped and the specific property isn't found locally. We will remove this sample fallback and replace it with a robust repository/API fetch or graceful error handling if the property ID does not exist.

## Proposed Changes

### Notification Services

#### [MODIFY] [notification_service.dart](file:///C:/flutteryyy/project/to_let_app_/lib/app/data/services/notification/notification_service.dart)
- Remove the local `FlutterLocalNotificationsPlugin.show()` call inside `notifyNewListing`. The backend API call (`_baseUrl/api/sendNotification`) remains to trigger the server-side push notification to FCM topics, ensuring no local dummy notifications are fired client-side.

#### [MODIFY] [fcm_service.dart](file:///C:/flutteryyy/project/to_let_app_/lib/core/services/fcm_service.dart)
- Remove references to `ToLetModel.sampleData` in `_handleNotificationPayload` and `_handleMessageData`.
- Instead of falling back to sample data, fetch the property item from the actual local datasource or repository, or navigate only when valid real data/ID is available.

## Verification Plan

### Automated Tests
- Build check: Run `flutter analyze` or `flutter build` to ensure no syntax errors or missing references.

### Manual Verification
- Verify that triggering a listing creation calls the backend API without showing a local hardcoded notification on the sending device.
- Verify that incoming FCM notifications correctly parse payload data without defaulting to dummy sample listings.
