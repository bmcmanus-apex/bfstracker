# BFS Tracker

### 1. Define Requirements

#### Functional Requirements:
- User registration and authentication
- Profile management (birth date, weight, height)
- Activity tracking
- Goal setting and progress tracking
- Notifications and reminders

#### Non-Functional Requirements:
- Scalability
- High availability
- Security for user data
- Responsiveness and performance

### 2. Choose Technologies

#### Backend:
- **Language:** Python
- **Framework:** FastAPI (for REST endpoints) and gRPC for communication
- **Database:** Firebase Firestore (NoSQL, cost-effective, scalable)
- **Authentication:** Firebase Authentication
- **Hosting:** Google Cloud Run (serverless platform)

#### Frontend:
- **Mobile App:** Swift (iOS) with SwiftUI
- **Web App:** React

### 3. System Architecture

#### High-Level Architecture:
1. **Client Applications:**
   - iOS App (Swift)
   - Web App (React)

2. **Backend Services:**
   - **User Service:** Handles user registration, authentication, and profile management
   - **Activity Service:** Manages activity tracking and goal setting

3. **Database:**
   - Firebase Firestore for storing user data, profiles, activities, etc.

4. **Hosting:**
   - Google Cloud Run for running the backend services

#### Detailed Architecture:

1. **Client Applications:**
   - **iOS App (Swift):**
     - Interacts with the backend using gRPC
     - Manages local state and UI rendering with SwiftUI
     - Supports multiple user profiles

   - **Web App (React):**
     - Interacts with the backend using gRPC
     - Manages state with Redux or Context API

2. **Backend Services:**
   - **User Service:**
     - **Endpoints:** /register, /login, /profile
     - **Responsibilities:** Authentication, profile management
     - **Database Collections:** Users, UserProfiles

   - **Activity Service:**
     - **Endpoints:** /activities, /goals, /progress
     - **Responsibilities:** Tracking activities, managing goals, recording progress
     - **Database Collections:** Activities, Goals, Progress

3. **Database:**
   - **Firebase Firestore:**
     - Cost-effective, scalable, and serverless
     - Stores user profiles, activities, goals

### 4. Implementation Steps

#### Backend

1. **Set Up Firebase:**
   - Create a Firebase project
   - Enable Firestore and Authentication
   - Set up Firebase Firestore rules to secure your data

2. **Develop Backend Services:**
   - Install necessary packages:
     ```bash
     pip install fastapi grpcio google-cloud-firestore firebase-admin
     ```
   - Set up gRPC with FastAPI for Python
   - Implement user authentication and profile management using Firebase Authentication
   - Implement CRUD operations for activities and goals using Firestore

3. **Example Python Code:**

   ```python
   from fastapi import FastAPI, Depends
   from firebase_admin import auth, firestore, initialize_app

   # Initialize Firebase
   initialize_app()
   db = firestore.client()

   app = FastAPI()

   @app.post("/register")
   async def register(email: str, password: str):
       user = auth.create_user(email=email, password=password)
       return {"uid": user.uid}

   @app.post("/login")
   async def login(id_token: str):
       decoded_token = auth.verify_id_token(id_token)
       uid = decoded_token['uid']
       return {"uid": uid}

   @app.post("/profile")
   async def create_profile(uid: str, birth_date: str, weight: float, height: float):
       db.collection('UserProfiles').document(uid).set({
           "birth_date": birth_date,
           "weight": weight,
           "height": height
       })
       return {"status": "Profile created"}

   @app.get("/profile/{uid}")
   async def get_profile(uid: str):
       profile = db.collection('UserProfiles').document(uid).get()
       return profile.to_dict()
   ```

#### Mobile App (iOS)

1. **Set Up Xcode Project:**
   - Create a new SwiftUI project in Xcode
   - Add dependencies for gRPC using Swift Package Manager

2. **Implement Authentication and Data Fetching:**
   - Use Firebase Authentication SDK for user login and registration
   - Implement gRPC client to communicate with the backend

3. **Example Swift Code:**

   ```swift
   import SwiftUI
   import Firebase
   import GRPC

   @main
   struct FitnessTrackerApp: App {
       init() {
           FirebaseApp.configure()
       }

       var body: some Scene {
           WindowGroup {
               ContentView()
           }
       }
   }

   struct ContentView: View {
       var body: some View {
           Text("Fitness Tracker")
       }
   }
   ```

#### Web App

1. **Set Up React Project:**
   - Create a new React project using Create React App
   - Add dependencies for gRPC-Web

2. **Implement Authentication and Data Fetching:**
   - Use Firebase Authentication for user login and registration
   - Implement gRPC-Web client to communicate with the backend

3. **Example React Code:**

   ```javascript
   import React, { useState, useEffect } from 'react';
   import firebase from 'firebase/app';
   import 'firebase/auth';
   import { grpc } from '@improbable-eng/grpc-web';

   const firebaseConfig = {
       apiKey: "YOUR_API_KEY",
       authDomain: "YOUR_AUTH_DOMAIN",
       projectId: "YOUR_PROJECT_ID",
       storageBucket: "YOUR_STORAGE_BUCKET",
       messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
       appId: "YOUR_APP_ID"
   };

   firebase.initializeApp(firebaseConfig);

   function App() {
       const [user, setUser] = useState(null);

       useEffect(() => {
           firebase.auth().onAuthStateChanged(setUser);
       }, []);

       return (
           <div>
               {user ? (
                   <div>Welcome, {user.email}</div>
               ) : (
                   <button onClick={login}>Login</button>
               )}
           </div>
       );

       function login() {
           const provider = new firebase.auth.GoogleAuthProvider();
           firebase.auth().signInWithPopup(provider);
       }
   }

   export default App;
   ```

### 5. Deploy and Test

1. **Deploy Backend to Google Cloud Run:**
   - Containerize your Python application using Docker
   - Deploy the container to Google Cloud Run

   ```bash
   gcloud builds submit --tag gcr.io/YOUR_PROJECT_ID/backend
   gcloud run deploy backend --image gcr.io/YOUR_PROJECT_ID/backend --platform managed
   ```

2. **Deploy Mobile App:**
   - Test on simulators and real devices
   - Submit to the App Store

3. **Deploy Web App:**
   - Host your web app on Firebase Hosting or another hosting provider
   - Set up CI/CD pipelines for automated testing and deployment

### 6. Monitoring and Maintenance

1. **Monitoring:**
   - Use Firebase Analytics for user behavior tracking
   - Set up logging and monitoring for backend services using Google Cloud Monitoring

2. **Maintenance:**
   - Regularly update dependencies and libraries
   - Address user feedback and implement new features
   - Ensure security patches are applied promptly

