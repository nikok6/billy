# Billy - Split Bill App

Billy is a mobile application that simplifies bill splitting with friends. You can effortlessly divide expenses and even scan receipts using AI to calculate each person's share based on the items in the receipt.

## Features

- **Split Bills**: Easily split bills among friends with just a few taps.
- **Receipt Scanning**: Scan and extract items from receipts using AI.
- **Multi-Platform**: Works seamlessly on iOS and Android devices.

## Getting Started

To get started with Billy, follow these steps:

1. **Clone the Repository**: `git clone https://github.com/nikok6/billy.git`

2. **Navigate to the Project Directory**: `cd billy`

3. **Install Dependencies**: Run `flutter pub get` to install the required packages.

4. **Run the App**: Launch the app on an emulator or physical device using `flutter run`.

## Dependencies

Billy relies on the following Flutter packages:

- [provider](https://pub.dev/packages/provider): For state management.
- [flutter_bloc](https://pub.dev/packages/flutter_bloc): For managing the UI components.
- [camera](https://pub.dev/packages/camera): For capturing images (if required).
- [firebase_ml_vision](https://pub.dev/packages/firebase_ml_vision): For receipt scanning using AI.
- [http](https://pub.dev/packages/http): For making API calls to your backend.

## Usage

1. Upon launching the app, create or join a group with your friends.
2. Use the built-in receipt scanner to scan your receipt.
3. The AI will automatically extract items, and you can verify them.
4. Split the bill among group members, and it's done!

## License

This project is licensed under the [MIT License](LICENSE).
