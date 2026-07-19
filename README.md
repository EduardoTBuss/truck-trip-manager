# truck-trip-manager — Trip Management for Road Freight

> A cross-platform Flutter app for trucking companies and independent truck drivers: fleet control, per-driver performance analytics, vehicle-combination fuel efficiency, and automated PDF trip reports.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat&logo=dart&logoColor=white)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)

## Overview

Truck Trip Manager is a mobile, offline-first solution for recording and analyzing road freight operations. It surfaces insights on operational efficiency, per-trip costs, driver performance, and fuel consumption per tractor/trailer combination.

## Architecture

The app uses persistent local storage via SharedPreferences, so all data remains available offline. It follows an MVC-style separation of concerns:

- **Models**: immutable data structures for trips, freight loads, and expenses
- **Services**: business logic for persistence and report generation
- **Screens**: UI organized by functional module
- **Widgets**: reusable components for visual consistency

### Tech Stack

- **Flutter 3.0+** — cross-platform framework
- **Dart 3.0+** — strongly typed language
- **Material Design 3** — modern, responsive design system
- **SharedPreferences** — key-value local storage
- **pdf** + **printing** — PDF generation, preview, and sharing

## Main Features

### 1. Authentication

Local password-based access control with a first-run onboarding flow, minimum password validation, password change in settings, and visual error feedback on wrong attempts.

### 2. Trip Logging

Each trip records driver and vehicle data (driver name, tractor plate, trailer plate, trip number), trip details (departure/arrival dates, fuel liters, odometer start/end with automatic distance and km/L computation), multiple freight loads per trip (origin, destination, value, notes), categorized expenses (diesel, tolls, parking, tire service, mechanic, misc), and an automatic financial summary (total freight revenue, driver commission, total expenses, trip balance, cash carried to the next trip).

### 3. Analytics Dashboard

Consolidated KPIs across all operations: total trips, accumulated mileage, freight revenue, operating expenses, driver commissions, average mileage per trip, fleet-wide average fuel consumption, and a consolidated profit indicator (revenue − expenses − commissions).

### 4. Driver Profile

Per-driver deep dive: total commissions, total mileage, number of freight loads carried, and average fuel consumption. The app identifies every unique tractor+trailer combination the driver used and computes, for each one, trip count, mileage, liters consumed, specific km/L, and percentage deviation from the driver's overall average — highlighting the most efficient configuration. This supports decisions like which vehicle combination to assign to long routes, which vehicles need maintenance, and fleet replacement planning.

### 5. PDF Trip Reports

Professional PDF reports following the traditional trip-sheet layout used in the freight industry: trip header, driver and vehicle data, mileage and fuel details, freight list, itemized expenses, and the computed financial summary. PDFs can be previewed, printed, or shared directly from the app.

### 6. Light & Dark Themes

Persisted theme preference applied across the whole interface.

## Installation

### Prerequisites

- Flutter SDK 3.0+ and Dart SDK 3.0+
- Android Studio or VS Code
- Android/iOS device or emulator

### Steps

```bash
git clone https://github.com/EduardoTBuss/truck-trip-manager
cd truck-trip-manager/src

flutter pub get

# Development
flutter run -d chrome    # web
flutter run -d android   # Android
flutter run -d ios       # iOS

# Production builds
flutter build apk --release
flutter build appbundle --release
flutter build ios --release
```

## Project Structure

```
src/lib/
├── main.dart                            # App entry point
├── models/
│   └── trip_model.dart                  # Trip model with freights and expenses
├── screens/
│   ├── splash_screen.dart
│   ├── onboarding_screen.dart
│   ├── settings_screen.dart
│   ├── auth/                            # set_password_screen, login_screen
│   ├── home/                            # home_screen, dashboard_screen, driver_profile_screen
│   └── trip/                            # add_trip_screen
├── widgets/                             # trip_card, stat_card
├── services/                            # storage_service, pdf_service
└── theme/                               # app_theme (light/dark)
```

## Data Flow

1. A new trip is converted to a `TripModel`, serialized to JSON by `StorageService`, and stored via SharedPreferences.
2. Statistics are computed by iterating over stored trips, grouping by driver and then by vehicle combination, and accumulating metrics.
3. `PdfService` receives a trip model, computes totals, and renders the standard trip-sheet layout.

## Roadmap

Cloud sync (Firebase/Supabase), Excel export, fuel price APIs, route geocoding, preventive maintenance alerts, predictive consumption analysis, i18n (PT/ES/EN), web dashboard, REST API for ERP integration.

## License

MIT — see [LICENSE](LICENSE).
