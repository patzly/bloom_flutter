# 📱 Bloom App

## 🌐 Abstract

**Bloom** is a Flutter-based mobile application designed to help users regulate their screen time in a motivating and positive way. By tracking usage and encouraging regular breaks, it promotes healthier digital habits and supports overall well-being.

## 🧭 Vision

Bloom motivates users to spend more time offline by connecting their digital habits to the health of a digital flower — encouraging balance between screen use and real-life moments.

## 💡 Problem

In everyday life, users in Germany (and beyond) often spend too much time on their smartphones. Excessive usage can negatively affect sleep quality, concentration, and mental health. However, limiting screen time independently can be difficult. Bloom provides gentle support and guidance to build better habits.

## 📖 Detailed Description

Bloom is tailored for people who spend long periods on their phones or tablets. It monitors:

- **Screen time**: total time the display is active
- **Session time**: how long the user actively uses the device in one go

Based on customizable thresholds, the app reminds users to take breaks and enforces limits gently when needed. If the user locks or unlocks the phone, Bloom recalculates remaining session time intelligently.

All settings — such as maximum session length and break duration — are stored using persistent local storage, allowing seamless continuity between sessions.

Break times are automatically subtracted from active sessions to ensure a smooth, personalized experience.

## 👤 Target Persona

**Name:** Emma  
**Age:** 25  
**Occupation:** University Student  
**Habits:** Uses her smartphone extensively for studying, messaging, and social media  
**Pain Point:** Struggles to manage screen time and often feels digitally fatigued  
**How Bloom Helps:** Emma uses Bloom to set healthy usage limits, take regular breaks, and improve her sleep and focus

## 🧭 Screens Overview

| Screen             | Description                                                                    |
|--------------------|--------------------------------------------------------------------------------|
| **Home Screen**     | Displays current session and screen time stats with clear visual indicators    |
| **Settings Screen** | Allows users to adjust session duration, break length, and screen time cap     |

## 📸 Screenshots
<div style="display: flex; gap: 5px;">
  <img src="assets/screenshots/home_screen.png" alt="Home Screen" width="250"/>
  <img src="assets/screenshots/settings_screen.png" alt="Swipe Screen" width="250"/>
</div>


## 🏗 **Architecture**

Bloom follows a **modular architecture** inspired by MVC principles, focusing on clear separation of concerns and platform abstraction. Each layer is responsible for a specific part of the app and interacts only through well-defined interfaces.

## 🧱 **Layers**

### 🖥️ **View Layer**  
Responsible for rendering the user interface. Contains widgets and screens that display data, receive user input, and forward actions to the controller. No business logic is included here.

### 🧩 **Controller Layer**  
Handles interaction logic and application flow. It interprets user actions, communicates with services, and updates the UI based on results.

### ⚙️ **Service Layer**  
Contains core app functionality such as time tracking, session handling, and break logic.


