# Kigali City Services Directory 🇷🇼

A fully functional, backend-connected Flutter mobile application designed to help Kigali residents and visitors locate essential public services, leisure spots, and lifestyle locations.

This project demonstrates clean architecture, real-time cloud database integration, and scalable state management.

## Features
* **Secure Authentication:** User signup, login, and logout using Firebase Authentication with enforced Email Verification.
* **Real-time Directory (CRUD):** Users can Create, Read, Update, and Delete location listings (e.g., Hospitals, Cafés, Police Stations) saved in Firebase Cloud Firestore.
* **Search & Filter:** Dynamic, real-time filtering of places by category and text search.
* **Map Integration:** Embedded Google Maps displaying specific location pins based on Firestore geographic coordinates.
* **Turn-by-turn Navigation:** Deep linking to launch Google Maps for route navigation to a selected listing.

---

## Architecture & State Management
This application strictly follows a **Clean Architecture** pattern to separate the user interface from business logic and database interactions.

**State Management Approach: `Provider`**
* **UI Widgets (`/screens`):** Only responsible for rendering the UI and calling Provider methods. They **do not** contain direct Firebase queries.
* **State Layer (`/providers`):** `AuthProvider` and `ListingProvider` manage the app's state (loading, success, errors) and reactively rebuild the UI when data changes.
* **Service Layer (`/services`):** `AuthService` and `FirestoreService` handle all direct communication with Firebase APIs.
* **Data Layer (`/models`):** Dart classes (`Listing`, `User`) that serialize and deserialize data to and from Firestore JSON maps.

---

## Firestore Database Structure
The database utilizes a NoSQL document structure with two main top-level collections:

### 1. `users` Collection
Stores user profiles created upon successful registration.
* `uid` (String) - Document ID matching Firebase Auth UID
* `email` (String)
* `role` (String) - Default is `'user'`
* `createdAt` (Timestamp)

### 2. `listings` Collection
Stores all directory locations and services.
* `id` (String) - Auto-generated Document ID
* `name` (String) - e.g., `"Kigali Heights"`
* `category` (String) - e.g., `"Restaurant"`, `"Hospital"`
* `address` (String)
* `contact` (String)
* `description` (String)
* `latitude` (Number/Double) - Geographic coordinate
* `longitude` (Number/Double) - Geographic coordinate
* `createdBy` (String) - The UID of the user who created it (used for "My Listings" filtering)
* `timestamp` (Timestamp) - Used to order listings chronologically

*(Note: A composite index is configured in Firestore to allow querying listings by `createdBy` and ordering by `timestamp` simultaneously.)*

---

## Navigation
The application utilizes a `BottomNavigationBar` within a `MainScreen` wrapper to handle core routing:

1. **Directory Screen:** The shared public feed of all listings, including the search bar and category filter chips.
2. **My Listings Screen:** A user-specific feed showing only locations created by the authenticated user, containing Edit and Delete functionalities.
3. **Map Screen:** A global Google Map view rendering markers for all directory listings.
4. **Settings Screen:** Displays the current user's profile info (Email/UID), a local mock-toggle for notifications, and the Logout button.
5. **Detail & Form Screens:** Nested routes pushed over the main navigation for viewing a specific place (`ListingDetailScreen`) or adding/editing a place (`ListingFormScreen`).

---

## Firebase Setup Instructions (To run locally)

If you are cloning this repository, you must connect it to your own Firebase project:

1. **Create a Firebase Project:** Go to the [Firebase Console](https://console.firebase.google.com/) and create a new project.
2. **Enable Services:**
   * Enable **Authentication** (Email/Password provider).
   * Enable **Firestore Database** (Start in Test Mode, Region: `us-central1`).
3. **Android Setup:**
   * Register an Android app in Firebase using the package name found in `android/app/build.gradle` (e.g., `com.example.kigali_city_directory`).
   * Download the `google-services.json` file.
   * Place the `google-services.json` file inside the `android/app/` directory of this project.
4. **Run the App:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```
