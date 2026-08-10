# Firebase Setup & Submission Guide

All the Flutter/Firebase **code is already done** (model, state management with CRUD,
sending data to Firestore, and a live `StreamBuilder` screen). You only need to do the
account-tied steps below, because they require logging into *your* Google and GitHub
accounts.

---

## Part A — Create the Firebase project
1. Go to https://console.firebase.google.com and sign in with your Google account.
2. Click **Add project** (or **Create a project**).
3. Name it e.g. `cse464-coffee-app` → Continue.
4. Disable Google Analytics (not needed) → **Create project** → wait → **Continue**.

## Part B — Enable Firestore + open the rules
1. In the left menu: **Build → Firestore Database → Create database**.
2. Choose a location (any) and start in **test mode** → Enable.
3. Go to the **Rules** tab and paste exactly this, then **Publish**:
   ```
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /{document=**} {
         allow read, write: if true;
       }
     }
   }
   ```
   This allows read / write / update as required by the assignment.

## Part C — Connect Firebase to this Flutter app
Run these in a terminal, inside this project folder.

1. Install the Firebase CLI and log in:
   ```bash
   curl -sL https://firebase.tools | bash
   firebase login
   ```
2. Install the FlutterFire CLI:
   ```bash
   dart pub global activate flutterfire_cli
   ```
   (If `flutterfire` isn't found, add pub-cache to PATH:
   `export PATH="$PATH":"$HOME/.pub-cache/bin"`)
3. From the project root, run:
   ```bash
   flutterfire configure
   ```
   - Pick the Firebase project you created in Part A.
   - Select the platforms you'll demo (Android is easiest; add iOS/web if you want).
   - This **auto-generates `lib/firebase_options.dart`** and the native config files.
     `main.dart` already imports and uses it — nothing else to wire up.
4. Fetch packages and run:
   ```bash
   flutter pub get
   flutter run
   ```

## Part D — Verify it works
- Tap **Order Now** → fill the form → **Save Coffee Record**.
- Tap **View Firebase Records (Live)** on the home screen.
- The record appears instantly (real-time snapshot). Editing/deleting from that screen
  updates Firestore, and you can watch the same data appear in the Firebase Console
  under Firestore Database → `coffeeRecords` collection.

---

## Part E — Create your GitHub repo (correct name!)
Repo name **must** be exactly this format:
```
Flutter Bonus Assignment - <Your Name> - <Student ID> - <Section>
```
Example: `Flutter Bonus Assignment - John Doe - 2110000 - Section 1`

Then push:
```bash
git add .
git commit -m "Firebase Firestore CRUD + real-time StreamBuilder"
git branch -M main
git remote add origin <YOUR_NEW_REPO_URL>
git push -u origin main
```

## Part F — Video + submission
1. Record a screen video of the app: add a record, show it appear live, show the same
   data in the Firebase Console, then edit/delete.
2. Upload to Google Drive (set link sharing to "Anyone with the link").
3. In Google Classroom, submit the GitHub repo link and paste the Drive video link in the
   **private comment**.

Checklist before submitting:
- [ ] Firebase connected (`firebase_options.dart` generated, app runs)
- [ ] Add / view (live) / edit / delete all work
- [ ] Repo name matches the required format
- [ ] Video + repo link submitted
