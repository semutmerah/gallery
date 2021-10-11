This repository is forked from https://github.com/flutter/gallery


# How to run the integration_tests
## Prerequisites
- Install Java JDK/Open JDK version 1.8.x, don't forget to set JAVA_HOME env
- Install Android SDK (for example, inside $HOME/Android/Sdk dir), and set ANDROID_HOME and ANDROID_SDK_ROOT env in ~.bashrc / ~.profile / ~.zshrc
```
export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
export ANDROID_HOME="$HOME/Android/Sdk"
```
- Install Flutter SDK. Set release channel to master
```
$ flutter channel master
```
- Setup one Android AVD Emulator, choose version 10 images (Android Q). For better performance, choose x86_64 arch
- Clone this repo to local machine
- Import flutter lib by running this command:
```
$ flutter pub get
```

## Run the test
The integration_test located at integration_test/app_test.dart. To start running the test, launch the android emulator first, then run this command:
```
$ flutter test integration_test
```

Below is the record when the test running:


## Best practices
On the production ready app, this integration test should be run inside CI/CD environment. On the high level, the flow pretty much like this:
