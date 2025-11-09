const admin = require('firebase-admin');
const logger = require('../utils/logger');

let db = null;
let auth = null;

/**
 * Initialize Firebase Admin SDK
 */
function initializeFirebase() {
  try {
    // Check if already initialized
    if (admin.apps.length > 0) {
      logger.info('Firebase Admin SDK already initialized');
      return;
    }

    // Skip Firebase in test/demo mode if no credentials
    if (process.env.NODE_ENV === 'development' && !process.env.FIREBASE_SERVICE_ACCOUNT) {
      try {
        require('./serviceAccountKey.json');
      } catch (e) {
        logger.warn('Firebase credentials not found. Running in demo mode without Firebase.');
        logger.warn('To use Firebase: Follow docs/FIREBASE_SETUP.md');
        return;
      }
    }

    // Initialize with service account
    // In production, use environment variables or secret manager
    const serviceAccount = process.env.FIREBASE_SERVICE_ACCOUNT
      ? JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT)
      : require('./serviceAccountKey.json'); // For local development

    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount),
      databaseURL: process.env.FIREBASE_DATABASE_URL,
      storageBucket: process.env.FIREBASE_STORAGE_BUCKET,
    });

    db = admin.firestore();
    auth = admin.auth();

    logger.info('Firebase Admin SDK initialized successfully');
  } catch (error) {
    logger.error('Error initializing Firebase Admin SDK:', error);
    if (process.env.NODE_ENV === 'development') {
      logger.warn('Continuing in demo mode. Some features will not work.');
    } else {
      throw error;
    }
  }
}

/**
 * Get Firestore database instance
 */
function getFirestore() {
  if (!db) {
    throw new Error('Firestore not initialized. Call initializeFirebase() first.');
  }
  return db;
}

/**
 * Get Firebase Auth instance
 */
function getAuth() {
  if (!auth) {
    throw new Error('Firebase Auth not initialized. Call initializeFirebase() first.');
  }
  return auth;
}

/**
 * Verify Firebase ID token
 */
async function verifyToken(idToken) {
  try {
    const decodedToken = await auth.verifyIdToken(idToken);
    return decodedToken;
  } catch (error) {
    logger.error('Error verifying token:', error);
    throw error;
  }
}

module.exports = {
  initializeFirebase,
  getFirestore,
  getAuth,
  verifyToken,
  admin,
};
