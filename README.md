# Simple dice

An application for WearOS watches to roll a die.

# Compile the app

To compile it, run the following command in the terminal:
```
 $ flutter build apk
```

The APK is generated in the following path: `build/app/outputs/flutter-apk/app-release.apk`. The APK can be downloaded and installed on the device.

The app version is defined directly in the gradle file in `android/app/build.gradle` (and not taken from `local.properties`).