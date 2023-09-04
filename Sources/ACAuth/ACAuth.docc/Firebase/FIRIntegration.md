# Integration guide

## Step 1: Create a Firebase project
Before you can add Firebase to your Apple app, you need to create a Firebase project to connect to your app. Visit Understand Firebase Projects to learn more about Firebase projects.

## Step 2: Register your app with Firebase
To use Firebase in your Apple app, you need to register your app with your Firebase project. 
Registering your app is often called "adding" your app to your project.

- Note: Check out our best practices for adding apps to a Firebase project, including how to handle multiple variants.
1. Go to the Firebase console.

2. In the center of the project overview page, click the iOS+ icon to launch the setup workflow.

3. If you've already added an app to your Firebase project, click Add app to display the platform options.

4. Enter your app's bundle ID in the bundle ID field.

- Warning: Make sure to enter the bundle ID that your app is actually using. The bundle ID value is case-sensitive, and it cannot be changed for this Firebase Apple app after it's registered with your Firebase project.
4. (Optional) Enter other app information: App nickname and App Store ID.

5. Click Register app.

## Step 3: Add a Firebase configuration file
1. Click Download `GoogleService-Info.plist` to obtain your Firebase Apple platforms config file (`GoogleService-Info.plist`).

2. Move your config file into the root of your Xcode project. If prompted, select to add the config file to all targets.

If you have multiple bundle IDs in your project, you must associate each bundle ID with a registered app in the Firebase console so that each app can have its own `GoogleService-Info.plist file`.

## Step 4: Initialize Firebase in your app
The final step is to add initialization code to your application. You may have already done this as part of adding Firebase to your app
1. Import the ACAuth module in your UIApplicationDelegate.

```swift 
import ACAuth
```

2. Configure using the ``ACFIRAuth/configure()`` method of the ``ACFIRAuth`` object in your app delegate's `application(_:didFinishLaunchingWithOptions:)` method:

```swift 
ACFIRAuth.configure()
```

## Troubleshot
If you're having trouble getting set up, though, visit the [official documentation](https://firebase.google.com/docs/ios/setup?hl=en#swift).
