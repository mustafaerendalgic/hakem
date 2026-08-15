# Hakem

### A mobile app for reporting and tracking workplace occupational health & safety (OHS) violations

[![Status](https://img.shields.io/badge/status-work%20in%20progress-orange)](#project-status) [![Flutter](https://img.shields.io/badge/Flutter-mobile%20application-02569B?logo=flutter)](https://flutter.dev) [![Dart](https://img.shields.io/badge/Dart-3.12%2B-0175C2?logo=dart)](https://dart.dev) [![State Management](https://img.shields.io/badge/state-BLoC%2FCubit-purple)](https://bloclibrary.dev)

**Hakem** ("referee" / "adjudicator" in Turkish) is a Flutter application built to help teams report, track, and review **İSG (İş Sağlığı ve Güvenliği — Occupational Health & Safety) violations** spotted on site: photograph or describe an issue, follow its investigation status, and browse open and resolved violations by severity.

> **This project is under active development.** It is being built during a Flutter developer internship at Çimko. Several screens described below reflect the target design and may not yet be fully implemented — see [Current Implementation](#current-implementation) for what actually exists in the codebase today.

---

## Screenshots

The screens below are Figma prototypes showing the intended design direction. The current in-app implementation is at an earlier stage — see [Current Implementation](#current-implementation).

<p align="center">
  <img src="https://github.com/user-attachments/assets/69249561-deb7-4b03-8eab-f7d61af99df6" width="260" alt="Hakem — login screen prototype" />
  <img src="https://github.com/user-attachments/assets/44bc44ec-545a-417f-b06b-698ff9f8fc30" width="260" alt="Hakem — home screen prototype" />
  <img src="https://github.com/user-attachments/assets/62722c61-73a0-4e90-ad39-2f19edfa320f" width="260" alt="Hakem — additional screen prototype" />
</p>

---

## Overview

On-site safety violations (blocked exits, missing PPE, hazardous storage, etc.) are easy to spot and easy to forget to report. Hakem is designed to make reporting fast and low-friction, and to give reviewers a clear, searchable view of what has been reported, what is still under investigation, and what has been resolved.

The application is designed around:

- **Reporting** — capturing a violation with a photo, description, and location.
- **Reviewing** — browsing violations filtered by severity and status.
- **Archiving** — accessing previously resolved or closed violations.
- **Analyzing** — surfacing trends across reported violations over time.

---

## Planned Core Features

### Violation Reporting
A dedicated capture flow (photo + description + location) for logging a new violation from the field.

### Violation Feed
A searchable, filterable home feed of active violations, each classified by risk level.

### Archive
A separate view for violations that have already been investigated, resolved, or posted, so the active feed stays focused on what's outstanding.

### Analysis
A dashboard summarizing violation trends — by location, risk level, or time — to help teams spot recurring problem areas.

### Notifications
Alerts for newly reported or escalated violations.

### Account
User profile and session management.

---

## Current Implementation

The repository currently contains the application's architecture, navigation, and core UI shell, built on a **BLoC/Cubit** foundation with a clean separation between UI, state, and data:

- **State management** — `flutter_bloc` with sealed state classes per feature (`ViolationStates`, `AuthenticationStates`), so every screen renders from an explicit, exhaustive set of states (loading / loaded / error).
- **Repository pattern** — a `HomeRepo` singleton exposes violation data as Dart `Stream`s, keeping the Cubit layer decoupled from the eventual data source. The current implementation returns mocked, empty streams; it is designed to be swapped for a real backend (Firebase or REST) without changing the Cubit or UI layers.
- **Custom navigation** — a `Session` singleton (`ChangeNotifier`) drives app-wide navigation through a `NavigationElement` enum, instead of relying on `BottomNavigationBar`'s built-in index state — this made it possible to trigger navigation from anywhere in the app (e.g. tapping the archive icon in the top app bar jumps straight to the Archive tab).
- **Custom bottom navigation bar** — a hand-built nav bar with a highlighted "pill" background on the active tab.
- **Reusable top app bar** — implements `PreferredSizeWidget`, with quick-access shortcuts to Archive and Notifications.
- **Reusable UI components** — a shared search bar, and an empty-state component (`SorryEmpty`) with a Lottie animation and a retry callback, used consistently across Home and Archive.
- **Mock authentication flow** — an email/password screen gates access to the rest of the app via `AuthenticationCubit`; there is no real backend behind it yet.
- **Design system** — `AppColors` defines a severity-based color scale (Az Tehlikeli / Tehlikeli / Çok Tehlikeli / Min Risk) alongside brand colors, and `TextStyles` centralizes a Gabarito-based type scale used across the app.
- **Routing shell** — Home, Archive, Photo, Analysis, Account, and Notifications are all wired into a single `Scaffold` via an enum-driven `switch`, with `Photo`, `Analysis`, `Account`, and `Notifications` currently placeholder screens awaiting their real implementation.

Camera-based violation capture, a real backend (Firebase or REST), the analysis dashboard, account management, and push notifications are still under development.

---

## Project Structure

```
lib/
├── data/
│   ├── cubits/          # AuthenticationCubit, ViolationCubit
│   ├── entity/           # Violation model
│   ├── repo/              # HomeRepo — data source abstraction (Stream-based)
│   ├── session/          # Session singleton + NavigationElement enum
│   └── states/            # Sealed state classes for each Cubit
├── theme/
│   ├── app_colors.dart   # Severity-based color system
│   └── text_styles.dart  # Centralized typography
├── ui/
│   ├── account/
│   ├── analysis/
│   ├── archives/
│   ├── authentication/
│   ├── common/            # SearchBarSection, SorryEmpty, TopAppBar
│   ├── home/
│   ├── notifications/
│   └── photo/
└── main.dart
```

---

## Technology Stack

### Currently Used

- **Flutter** — cross-platform application framework
- **Dart** — primary programming language
- **flutter_bloc (Cubit)** — state management with sealed state classes
- **Dart Streams** — real-time-ready data flow between the repository and Cubit layers
- **Lottie** — empty-state animations
- **Custom fonts** — Gabarito

### Planned Integrations

- A real backend (Firebase or REST API) to replace the mocked repository streams
- Camera access for on-site violation reporting
- Charting/analytics for the Analysis dashboard
- Push notifications

---

## Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK compatible with `^3.12.2`
- Android Studio or Visual Studio Code
- Android SDK/emulator or a physical device
- Xcode for iOS development on macOS

### Installation

```
git clone https://github.com/mustafaerendalgic/hakem.git
cd hakem
flutter pub get
flutter run
```

---

## Project Status

Hakem is an early-stage, actively developed project, built as part of a Flutter developer internship at Çimko. The current focus is establishing the architecture (state management, navigation, and reusable UI components) before wiring in a real backend and building out the remaining feature screens.

Because the project is still evolving:

- The data layer will change once a real backend is integrated.
- Screens may be redesigned to match the Figma prototypes.
- Folder structure may be refactored as new features are added.

---

## Roadmap

- [x] Project scaffolding and navigation structure
- [x] Cubit/BLoC state architecture with sealed states
- [x] Repository abstraction over violation data (Stream-based)
- [x] Custom bottom navigation and top app bar
- [x] Mock authentication flow
- [x] Home and Archive screens with empty-state handling
- [ ] Real backend integration for violation data
- [ ] Camera-based violation reporting flow
- [ ] Violation detail view and status updates
- [ ] Analysis dashboard
- [ ] Account management screen
- [ ] Push notifications
- [ ] Automated tests

---

## Author

Developed by [Mustafa Eren Dalgıç](https://github.com/mustafaerendalgic).
