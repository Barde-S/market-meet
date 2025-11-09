const { validationResult } = require('express-validator');
const { getAuth, getFirestore } = require('../config/firebase');
const logger = require('../utils/logger');

/**
 * Register new user
 */
async function register(req, res) {
  try {
    // Validate request
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { email, password, name, phoneNumber } = req.body;
    const auth = getAuth();
    const db = getFirestore();

    // Create user in Firebase Auth
    const userRecord = await auth.createUser({
      email,
      password,
      displayName: name,
    });

    // Create user document in Firestore
    await db.collection('users').doc(userRecord.uid).set({
      name,
      email,
      phoneNumber: phoneNumber || null,
      createdAt: new Date(),
      updatedAt: new Date(),
    });

    logger.info(`New user registered: ${userRecord.uid}`);

    res.status(201).json({
      message: 'User registered successfully',
      userId: userRecord.uid,
    });
  } catch (error) {
    logger.error('Registration error:', error);
    res.status(500).json({
      error: 'Registration failed',
      message: error.message,
    });
  }
}

/**
 * Login user (token verification handled by client)
 */
async function login(req, res) {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    // Note: Actual authentication happens on the client side with Firebase Auth
    // This endpoint can be used for additional server-side logic if needed

    res.status(200).json({
      message: 'Login endpoint - use Firebase Auth on client side',
    });
  } catch (error) {
    logger.error('Login error:', error);
    res.status(500).json({
      error: 'Login failed',
      message: error.message,
    });
  }
}

/**
 * Get current user profile
 */
async function getCurrentUser(req, res) {
  try {
    const db = getFirestore();
    const userDoc = await db.collection('users').doc(req.user.uid).get();

    if (!userDoc.exists) {
      return res.status(404).json({
        error: 'User not found',
      });
    }

    res.status(200).json({
      uid: req.user.uid,
      ...userDoc.data(),
    });
  } catch (error) {
    logger.error('Get current user error:', error);
    res.status(500).json({
      error: 'Failed to get user profile',
      message: error.message,
    });
  }
}

/**
 * Refresh authentication token
 */
async function refreshToken(req, res) {
  try {
    // Token refresh is handled by Firebase Auth on client side
    res.status(200).json({
      message: 'Token refresh handled by Firebase Auth SDK on client',
    });
  } catch (error) {
    logger.error('Refresh token error:', error);
    res.status(500).json({
      error: 'Token refresh failed',
      message: error.message,
    });
  }
}

module.exports = {
  register,
  login,
  getCurrentUser,
  refreshToken,
};
