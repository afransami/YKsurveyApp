# ভূমি সার্ভে ম্যানেজমেন্ট অ্যাপ — সম্পূর্ণ সেটআপ গাইড

## প্রজেক্ট স্ট্রাকচার

```
bhumi_survey_app/
├── lib/
│   ├── main.dart                    ← অ্যাপের প্রবেশপথ
│   ├── theme/
│   │   └── app_theme.dart           ← রঙ, ফন্ট, ডিজাইন সিস্টেম
│   ├── models/
│   │   └── models.dart              ← সব ডেটা মডেল (Client, Schedule...)
│   ├── services/
│   │   └── firebase_service.dart    ← Firebase CRUD অপারেশন
│   ├── widgets/
│   │   └── common_widgets.dart      ← পুনর্ব্যবহারযোগ্য UI কম্পোনেন্ট
│   └── screens/
│       ├── login_screen.dart        ← লগইন পেজ
│       ├── main_screen.dart         ← ড্যাশবোর্ড + নেভিগেশন
│       ├── client_screen.dart       ← ক্লায়েন্ট ব্যবস্থাপনা
│       ├── schedule_screen.dart     ← সিডিউল ক্যালেন্ডার
│       ├── dalil_screen.dart        ← দলিল / নামজারী / খতিয়ান
│       ├── advance_screen.dart      ← অগ্রিম টাকার হিসাব
│       └── khajna_screen.dart       ← খাজনার দাখিলা
├── pubspec.yaml
└── firestore.rules
```

---

## ধাপ ১ — Flutter ইনস্টল করুন

1. https://flutter.dev/docs/get-started/install থেকে Flutter SDK ডাউনলোড করুন
2. Android Studio ইনস্টল করুন: https://developer.android.com/studio
3. Terminal-এ চালান:
   ```bash
   flutter doctor
   ```
   সব ✅ হলে প্রস্তুত

---

## ধাপ ২ — Firebase প্রজেক্ট তৈরি করুন

### ২.১ Firebase Console
1. https://console.firebase.google.com যান
2. **"Create a project"** ক্লিক করুন
3. নাম দিন: `bhumi-survey`
4. Google Analytics বন্ধ রাখুন (ঐচ্ছিক)

### ২.২ Android App যোগ করুন
1. Project Overview > **Add app** > Android আইকন
2. Package name দিন: `com.yourname.bhumisurvey`
3. **"google-services.json"** ডাউনলোড করুন
4. ফাইলটি রাখুন: `android/app/google-services.json`

### ২.৩ Authentication চালু করুন
1. Firebase Console > **Authentication** > Get started
2. **Email/Password** Provider চালু করুন

### ২.৪ প্রথম ব্যবহারকারী তৈরি করুন
1. Authentication > Users > **Add user**
2. আপনার ইমেইল ও পাসওয়ার্ড দিন

### ২.৫ Firestore Database তৈরি করুন
1. Firebase Console > **Firestore Database** > Create database
2. **Production mode** বেছে নিন
3. Location: `asia-south1` (ভারত — বাংলাদেশের কাছাকাছি)

### ২.৬ Security Rules সেট করুন
1. Firestore > **Rules** ট্যাব
2. `firestore.rules` ফাইলের কন্টেন্ট পেস্ট করুন
3. **Publish** করুন

---

## ধাপ ৩ — Flutter প্রজেক্ট সেটআপ

### ৩.১ নতুন প্রজেক্ট তৈরি
```bash
flutter create bhumi_survey_app
cd bhumi_survey_app
```

### ৩.২ সব ফাইল কপি করুন
দেওয়া সব ফাইল তাদের নির্দিষ্ট ফোল্ডারে রাখুন

### ৩.৩ Firebase CLI দিয়ে কানেক্ট করুন
```bash
# Firebase CLI ইনস্টল
npm install -g firebase-tools

# লগইন
firebase login

# FlutterFire CLI ইনস্টল
dart pub global activate flutterfire_cli

# Firebase কানেক্ট করুন
flutterfire configure
```

### ৩.৪ android/build.gradle এ যোগ করুন
```gradle
// android/build.gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.4.0'
    }
}
```

### ৩.৫ android/app/build.gradle এ যোগ করুন
```gradle
apply plugin: 'com.google.gms.google-services'

android {
    defaultConfig {
        minSdkVersion 21   // এটি 21 করুন
    }
}
```

### ৩.৬ Packages ইনস্টল
```bash
flutter pub get
```

---

## ধাপ ৪ — অ্যাপ রান করুন

### এমুলেটরে
```bash
flutter run
```

### APK তৈরি করুন (ফোনে ইনস্টলের জন্য)
```bash
flutter build apk --release
```
APK পাওয়া যাবে: `build/app/outputs/flutter-apk/app-release.apk`

---

## অ্যাপের ফিচার সমূহ

| ফিচার | বিবরণ |
|-------|-------|
| 🔐 লগইন | Email/Password দিয়ে সুরক্ষিত লগইন |
| 👥 ক্লায়েন্ট | যোগ, সম্পাদনা, খোঁজ, ফিল্টার |
| 📅 সিডিউল | ক্যালেন্ডার ভিউ, তারিখ ও সময় নির্ধারণ |
| 📜 দলিল | ক্রয়-বিক্রয় রেজিস্ট্রি রেকর্ড |
| ⚖️ নামজারী | মামলা ট্র্যাকিং, শুনানির তারিখ অ্যালার্ট |
| 📋 খতিয়ান | নতুন খতিয়ান সৃজনের রেকর্ড |
| 💰 অগ্রিম | টাকা গ্রহণ ও সমন্বয়ের হিসাব |
| 🧾 খাজনা | দাখিলা রেকর্ড সংরক্ষণ |
| ☁️ ক্লাউড | Firebase-এ সব ডেটা, যেকোনো ডিভাইস থেকে |
| 🔔 নোটিফিকেশন | আসন্ন সিডিউল ও জরুরি মামলার অ্যালার্ট |

---

## দ্বিতীয় ব্যবহারকারী (কর্মচারী) যোগ করার নিয়ম

1. Firebase Console > Authentication > Add user
2. কর্মচারীর ইমেইল ও পাসওয়ার্ড দিন
3. Firestore > users collection-এ তার UID দিয়ে document তৈরি করুন:
   ```json
   {
     "name": "কর্মচারীর নাম",
     "email": "employee@example.com",
     "role": "employee",
     "createdAt": "timestamp"
   }
   ```

---

## সমস্যা হলে যোগাযোগ করুন

- Flutter: https://flutter.dev/docs
- Firebase: https://firebase.google.com/docs
- FlutterFire: https://firebase.flutter.dev
