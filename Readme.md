# EasyRoutes NSW - iOS Public Transport Journey Manager

## Table of Contents
1. [Introduction](#introduction)
2. [Installation](#installation)
3. [Usage](#usage)

## Introduction

**EasyRoutes NSW** is an iOS native app designed to help users manage their journeys through public transport in an efficient and effective manner. This app utilizes the Google Route API and MapKit for the transport routing system, with a primary focus on New South Wales (NSW). However, the routing system can potentially be applied to other regions, depending on the availability of the Google Route API.

Key Features:
- Real-time trip information and time calculations for walking to the nearest station.
- Data persistence using a combination of CoreData and CloudKit, enabling users to save routes locally and synchronize them across multiple devices sharing the same iCloud account.
- Support for Dark Mode.

## Installation

Before installing the app, you need to add a Swift file and complete it with your API keys for Google Map Service and Open Data Service. Here's how to set it up:

1. Create a Swift file (e.g., `SensitiveInfo.swift`) in your Xcode project.

2. Add the following code and replace `"Your info here"` with your actual API keys:

```swift
import Foundation

struct SensitiveInfo {
    struct GoogleMapService {
        static let API_KEY = "Your info here"
    }

    struct OpenDataService {
        static let API_KEY = "Your info here"
    }
}
```

3. Save the file.

4. The app is now ready to be installed. Please note that the current version of the app only supports iOS 16.6 or above.

## Usage

**EasyRoutes NSW** is user-friendly and makes planning your public transport journey a breeze. Here's how to use the app:

1. **Navigation Entry**: Start by tapping the navigation button to autofill your current location or manually type in your current location.

2. **Suggestions**: The app will display location suggestions in a list below. Select a suggestion, and the relevant field will be auto-completed.

3. **Route Suggestion**: Once all fields are filled, the suggested route will appear on the screen. If no route results are displayed, please re-enter the location information.

4. **Transit Cards**: Tap on any transit card to view geographical information on the map view. Depending on whether it's a departure or arrival point, different information will be shown to help you plan your trip. If you miss your train, the relevant field will display the arrival time.

5. **Save Routes**: You can save your routes by clicking the "Save" button. The saved route will be stored both locally and in the cloud, allowing synchronization across multiple devices that use the same iCloud account. Simply reopen the app on other devices, and the updates will be synchronized from the cloud automatically.

6. **Dark Mode**: For a better user experience, the app supports Dark Mode. You can toggle the display mode by going to the settings view.

Enjoy your hassle-free public transport journeys with EasyRoutes NSW!

For any questions or support, please contact guoyangru@gmail.com.

Thank you for using EasyRoutes NSW!
