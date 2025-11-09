# MarketMate: Shopping Assistance Platform for Travelers & Buyers

<div align="center">

**Connecting travelers and shoppers with trusted local agents for guided shopping experiences worldwide**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter)](https://flutter.dev)
[![Node.js](https://img.shields.io/badge/Node.js-18+-339933?logo=node.js)](https://nodejs.org)
[![Firebase](https://img.shields.io/badge/Firebase-Platform-FFCA28?logo=firebase)](https://firebase.google.com)

</div>

---

## 📋 Table of Contents

- [Overview](#overview)
- [Problem Statement](#problem-statement)
- [Solution](#solution)
- [Features](#features)
- [Technology Stack](#technology-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Documentation](#documentation)
- [Potential Impact](#potential-impact)
- [Contributing](#contributing)
- [License](#license)

---

## 🌟 Overview

MarketMate is a mobile platform that bridges the gap between travelers/shoppers and local market experts. It enables users to navigate unfamiliar markets, find specific items, and complete purchases through trusted, verified local agents who provide personalized assistance.

## 🎯 Problem Statement

Travelers, expatriates, and even local residents in unfamiliar cities often face several challenges:

- **Navigation Difficulties**: Large markets can be overwhelming and difficult to navigate
- **Trust Issues**: Uncertainty about vendor reliability and fair pricing
- **Language Barriers**: Communication challenges in foreign markets
- **Time Constraints**: Difficulty finding specific items efficiently
- **Safety Concerns**: Need for trusted guidance in unfamiliar areas

## 💡 Solution

MarketMate connects users with verified local agents who provide:

✅ **Market Escort Services** - Safe guidance through markets
✅ **Item Search & Procurement** - Finding specific goods on behalf of users
✅ **Purchase & Delivery** - Complete shopping service for remote buyers
✅ **Translation & Negotiation** - Language support and price negotiation

## ✨ Features

### For Users (Shoppers/Travelers)
- 🔍 Discover verified local agents based on location
- 📅 Book shopping assistance services
- 💬 Real-time messaging with agents
- 🗺️ GPS-based agent discovery and navigation
- ⭐ Rate and review agent services
- 🌐 Multi-language support

### For Agents (Local Assistants)
- 📱 Manage availability and bookings
- 💼 Create detailed profiles with specialties
- 💰 Set custom hourly rates
- 📊 Track earnings and reviews
- 🔔 Real-time booking notifications

### Platform Features
- 🔐 Secure Firebase authentication
- 📍 Google Maps integration
- 💳 Payment processing (planned)
- 🔔 Push notifications
- 📱 Cross-platform mobile app (iOS & Android)

## 🛠️ Technology Stack

### Mobile Application
- **Framework**: Flutter 3.0+
- **Language**: Dart
- **State Management**: Provider
- **Maps**: Google Maps Flutter Plugin
- **UI Components**: Material Design 3

### Backend
- **Runtime**: Node.js 18+
- **Framework**: Express.js
- **Database**: Firebase Firestore
- **Authentication**: Firebase Auth
- **Storage**: Firebase Storage
- **API**: RESTful API

### DevOps & Tools
- **Version Control**: Git
- **CI/CD**: GitHub Actions (planned)
- **Logging**: Winston
- **Testing**: Jest, Flutter Test

## 📁 Project Structure

```
market-meet/
├── mobile/                 # Flutter mobile application
│   ├── lib/
│   │   ├── config/        # App configuration
│   │   ├── models/        # Data models
│   │   ├── providers/     # State management
│   │   ├── screens/       # UI screens
│   │   ├── services/      # API and external services
│   │   ├── widgets/       # Reusable UI components
│   │   └── main.dart      # App entry point
│   ├── android/           # Android configuration
│   ├── ios/               # iOS configuration
│   └── pubspec.yaml       # Flutter dependencies
│
├── backend/               # Node.js backend server
│   ├── src/
│   │   ├── config/       # Configuration files
│   │   ├── controllers/  # Route controllers
│   │   ├── middleware/   # Custom middleware
│   │   ├── routes/       # API routes
│   │   ├── services/     # Business logic
│   │   ├── utils/        # Utility functions
│   │   └── server.js     # Server entry point
│   └── package.json      # Node dependencies
│
├── docs/                  # Documentation
│   ├── FIREBASE_SETUP.md
│   └── GOOGLE_MAPS_SETUP.md
│
└── README.md             # This file
```

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK**: 3.0.0 or higher
- **Dart SDK**: 3.0.0 or higher
- **Node.js**: 18.0.0 or higher
- **Firebase Account**: For backend services
- **Google Cloud Account**: For Maps API

### Quick Start

1. **Clone the repository**
   ```bash
   git clone https://github.com/Barde-S/market-meet.git
   cd market-meet
   ```

2. **Set up the mobile app**
   ```bash
   cd mobile
   flutter pub get
   ```

3. **Set up the backend**
   ```bash
   cd backend
   npm install
   cp .env.example .env
   # Edit .env with your configuration
   ```

4. **Configure Firebase**
   - Follow the guide in [docs/FIREBASE_SETUP.md](docs/FIREBASE_SETUP.md)

5. **Configure Google Maps**
   - Follow the guide in [docs/GOOGLE_MAPS_SETUP.md](docs/GOOGLE_MAPS_SETUP.md)

6. **Run the application**
   ```bash
   # Terminal 1: Run backend
   cd backend
   npm run dev

   # Terminal 2: Run mobile app
   cd mobile
   flutter run
   ```

## 📚 Documentation

- **[Firebase Setup Guide](docs/FIREBASE_SETUP.md)** - Complete Firebase integration guide
- **[Google Maps Setup Guide](docs/GOOGLE_MAPS_SETUP.md)** - Maps API configuration
- **[Mobile App README](mobile/README.md)** - Flutter app documentation
- **[Backend API README](backend/README.md)** - API documentation

## 🌍 Potential Impact

### Social Impact
- **Empowerment**: Creates micro-job opportunities for local residents
- **Cultural Exchange**: Facilitates meaningful cultural interactions
- **Economic Growth**: Supports local markets and small vendors
- **Accessibility**: Makes shopping accessible to diverse user groups

### Research & Publishability
MarketMate has high potential for academic publication in areas such as:
- Digital marketplaces and gig economy
- Cross-cultural technology platforms
- Human-guided commerce systems
- Location-based service platforms
- Trust and safety in peer-to-peer marketplaces

**Target Journals**:
- ACM Conferences (CHI, CSCW)
- Electronic Commerce Research
- Journal of Business Research
- International Journal of Electronic Commerce

## 🗺️ Roadmap

### Phase 1: MVP (Current)
- [x] Project structure setup
- [x] Basic authentication
- [x] Agent discovery
- [x] Booking system
- [ ] Real-time messaging
- [ ] Payment integration

### Phase 2: Enhancement
- [ ] Advanced search filters
- [ ] In-app navigation
- [ ] Review and rating system
- [ ] Agent verification process
- [ ] Multi-language support

### Phase 3: Scale
- [ ] Payment gateway integration
- [ ] Admin dashboard
- [ ] Analytics and reporting
- [ ] Marketing features
- [ ] Community features

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

Please ensure your code follows our coding standards and includes appropriate tests.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Authors

- **Project Lead** - Initial work and architecture

## 🙏 Acknowledgments

- Firebase for backend infrastructure
- Google Maps Platform for location services
- Flutter community for excellent plugins and support
- All contributors and testers

## 📧 Contact

For questions or support, please open an issue on GitHub or contact the maintainers.

---

<div align="center">

**Made with ❤️ for travelers and local communities worldwide**

[Report Bug](https://github.com/Barde-S/market-meet/issues) · [Request Feature](https://github.com/Barde-S/market-meet/issues) · [Documentation](docs/)

</div>
