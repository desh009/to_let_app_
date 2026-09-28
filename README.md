# To Let Khulna - House Rental App

A modern Flutter application for finding and listing rental properties in Khulna, Bangladesh.

## Features

### 🏠 Property Management
- Browse featured and recommended properties
- Advanced filtering (price, location, bedrooms, etc.)
- Property details with image gallery
- Post new listings
- Update and delete your listings

### 🔐 Authentication
- Email/Password login & registration
- Google OAuth (via Supabase)
- OTP verification
- Biometric login (Fingerprint/Face ID)
- Forgot password & reset

### 💬 Messaging
- Real-time chat with property owners
- Message notifications
- Conversation history

### 👤 Profile
- User profile management
- My listings
- Favorites
- Language selection (English/বাংলা)
- Dark mode

### 🎤 AI Voice Assistant
- Gemini AI voice search
- Voice commands for property search

## Tech Stack

- **Framework:** Flutter 3.x
- **State Management:** GetX
- **Backend:** Node.js REST API
- **Authentication:** Supabase + Custom API
- **Database:** PostgreSQL (via Supabase)
- **Real-time:** Supabase Realtime
- **AI:** Google Gemini API
- **Local Storage:** Shared Preferences
- **UI:** Custom Material Design

## Project Structure

```
lib/
├── app/                    # App-wide features
├── core/
│   ├── config/            # App configuration
│   ├── constants/         # Colors, strings, keys
│   ├── controllers/       # Global controllers
│   ├── network/           # API client
│   └── services/          # Core services
├── data/
│   ├── models/            # Data models
│   └── repositories/      # Data layer
├── domain/
│   └── entities/          # Business entities
├── routes/                # Navigation
├── screens/               # UI screens
└── widgets/               # Reusable widgets
```

## Setup

### Prerequisites
- Flutter SDK 3.x
- Dart SDK 3.x
- Android Studio / VS Code
- Node.js (for backend)

### Installation

1. **Clone the repository**
```bash
git clone <repository-url>
cd to_let_app_
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Setup environment variables**
```bash
cp .env.example .env
```

Edit `.env` and add your credentials:
```env
GEMINI_API_KEY=your_gemini_api_key
GOOGLE_CLIENT_ID=your_google_client_id
GOOGLE_CLIENT_SECRET=your_google_client_secret
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

4. **Run the app**
```bash
flutter run
```

## Configuration

### Backend API
Update `lib/core/config/urls.dart` with your backend URL:
```dart
static const String baseUrl = 'http://your-backend-url/api';
```

### Supabase
Configure in `lib/core/config/supabase_config.dart`

### Google OAuth
Add SHA-1 fingerprint for Android in Google Cloud Console

## Features in Detail

### Biometric Authentication
- Device-bound security
- One device per account
- Fingerprint/Face ID support
- Auto-detection of biometric type

### Shimmer Loading
- Modern loading animations
- Replaces circular progress indicators
- Dark mode compatible

### Real-time Messaging
- Supabase Realtime integration
- Instant message delivery
- Online/offline status

## Dependencies

Key packages:
- `get: ^4.6.6` - State management
- `supabase_flutter: ^2.8.0` - Backend services
- `shimmer: ^3.0.0` - Loading animations
- `local_auth: ^3.0.2` - Biometric authentication
- `flutter_dotenv: ^5.2.1` - Environment variables
- `image_picker: ^1.1.2` - Image selection
- `google_sign_in: ^6.2.1` - Google authentication

## Build & Release

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ipa --release
```

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is private and proprietary.

## Contact

For support or queries, contact the development team.
