📱 Bloom App
🌐 Abstract
Bloom is a Flutter-based mobile application that promotes healthier digital habits by helping users manage their screen time and session duration. It monitors screen usage and encourages regular breaks to avoid digital fatigue and promote well-being.

📖 Detailed Description
Bloom is designed for users who spend long hours on their smartphones or tablets. The app tracks how long the device screen remains active (screen time) and the duration of continuous usage sessions (session time). Based on configurable thresholds, it reminds users to take breaks and gently enforces boundaries if necessary. It also adjusts session behavior based on whether the user locked or unlocked the device, recalculating the remaining time accordingly.

It uses persistent storage to save session configurations (e.g. max session time, break length), ensuring continuity across app launches. The app applies intelligent logic to subtract break time from ongoing sessions, allowing a more dynamic and personalized experience.

💡 Problem Solved
Today's users often lose track of time spent on digital devices, which can lead to fatigue, decreased productivity, and health issues like eye strain or insomnia. Bloom solves this by:

Tracking screen and session usage

Enforcing healthy usage patterns with breaks

Adapting to user behavior in real time

👤 Target Persona
Name: Emma
Age: 25
Occupation: University Student
Habits: Uses phone for studying, social media, and communication for several hours daily.
Pain Point: Loses track of time and suffers from digital fatigue.
How Bloom helps: Emma uses Bloom to set healthy usage limits, take regular breaks, and improve her focus and sleep quality.

🧭 Screens Overview
Screen	Description
Home Screen	Shows current session and screen time stats, visual indicators for limits
Settings Screen	Lets users adjust max session duration, break time, and screen time cap
Break Screen	Encourages the user to take a break, possibly locking out for a moment
Stats Screen	Displays historical data about user’s screen and session usage
Onboarding	Guides the user through initial setup and permission requests

🧱 Architecture
The app follows a modular MVC-inspired architecture with Service Layer and Shared Preferences for persistent data.

Layers:
pgsql
Kopieren
Bearbeiten
+----------------------+
|       View (UI)      | ← Flutter Widgets & Screens
+----------------------+
           |
           ↓
+----------------------+
|     Controller       | ← Handles user interaction & navigation logic
+----------------------+
           |
           ↓
+----------------------+
|      Service Layer   | ← e.g. TimeServiceImpl: Manages timing logic
+----------------------+
           |
           ↓
+----------------------+
|   Local Persistence  | ← SharedPreferences (e.g. session time, screen time)
+----------------------+
Key Components:
TimeServiceImpl: Core logic for session and screen time tracking

SharedPreferences: Stores user settings and current session state

Constants: Central location for thresholds and update intervals

UserPresence: Enum that differentiates between OFF, LOCKED, and UNLOCKED states to adjust session timing
