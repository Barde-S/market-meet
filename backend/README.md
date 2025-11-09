# MarketMate Backend API

Node.js/Express backend server for MarketMate shopping assistance platform.

## Features

- **RESTful API**: Clean, organized API endpoints
- **Firebase Integration**: Firebase Admin SDK for authentication and Firestore database
- **Authentication**: JWT-based authentication with Firebase
- **Security**: Helmet, CORS, rate limiting
- **Logging**: Winston-based logging system
- **Validation**: Express-validator for input validation

## Tech Stack

- Node.js (18+)
- Express.js
- Firebase Admin SDK
- Winston (logging)
- Express Validator

## Prerequisites

- Node.js 18.0.0 or higher
- npm 9.0.0 or higher
- Firebase project with Firestore enabled

## Setup

1. **Install dependencies**:
   ```bash
   npm install
   ```

2. **Configure environment variables**:
   ```bash
   cp .env.example .env
   ```
   Then edit `.env` with your configuration.

3. **Firebase Setup**:
   - Go to Firebase Console > Project Settings > Service Accounts
   - Generate a new private key
   - Save as `src/config/serviceAccountKey.json` (for development)
   - For production, use `FIREBASE_SERVICE_ACCOUNT` environment variable with JSON string

4. **Start the server**:
   ```bash
   # Development mode with auto-reload
   npm run dev

   # Production mode
   npm start
   ```

## API Endpoints

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login user
- `GET /api/auth/me` - Get current user profile

### Agents
- `GET /api/agents` - Get all verified agents
- `GET /api/agents/nearby` - Get nearby agents
- `GET /api/agents/:id` - Get agent by ID
- `POST /api/agents/profile` - Create/update agent profile
- `PUT /api/agents/availability` - Update agent availability
- `GET /api/agents/:id/reviews` - Get agent reviews

### Bookings
- `POST /api/bookings` - Create new booking
- `GET /api/bookings/user/:userId` - Get user bookings
- `GET /api/bookings/agent/:agentId` - Get agent bookings
- `GET /api/bookings/:id` - Get booking by ID
- `PUT /api/bookings/:id/status` - Update booking status
- `DELETE /api/bookings/:id` - Cancel booking

### Users
- `GET /api/users/profile` - Get user profile
- `PUT /api/users/profile` - Update user profile
- `GET /api/users/:id` - Get user by ID

## Project Structure

```
backend/
├── src/
│   ├── config/          # Configuration files
│   │   └── firebase.js  # Firebase Admin setup
│   ├── controllers/     # Route controllers
│   ├── middleware/      # Custom middleware
│   ├── models/          # Data models
│   ├── routes/          # API routes
│   ├── services/        # Business logic
│   ├── utils/           # Utility functions
│   │   └── logger.js    # Winston logger
│   └── server.js        # App entry point
├── logs/                # Log files
├── .env.example         # Environment variables template
└── package.json         # Dependencies
```

## Authentication

All protected endpoints require a Firebase ID token in the Authorization header:

```
Authorization: Bearer <firebase-id-token>
```

## Error Handling

The API uses standard HTTP status codes:

- `200` - Success
- `201` - Created
- `400` - Bad Request
- `401` - Unauthorized
- `403` - Forbidden
- `404` - Not Found
- `500` - Internal Server Error

## Logging

Logs are stored in the `logs/` directory:
- `combined.log` - All logs
- `error.log` - Error logs only

## Testing

```bash
npm test
```

## License

MIT License - See LICENSE file for details
