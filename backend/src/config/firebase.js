const admin = require('firebase-admin');
const logger = require('../utils/logger');
const fs = require('fs');
const path = require('path');

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

    // Check for service account credentials
    let serviceAccount = null;

    if (process.env.FIREBASE_SERVICE_ACCOUNT) {
      // Use environment variable (production)
      serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);
    } else {
      // Check for local service account file (development)
      const serviceAccountPath = path.join(__dirname, 'serviceAccountKey.json');

      if (fs.existsSync(serviceAccountPath)) {
        serviceAccount = require('./serviceAccountKey.json');
      } else {
        // No credentials found - run in demo mode
        logger.warn('═══════════════════════════════════════════════════════');
        logger.warn('Firebase credentials not found. Running in DEMO MODE.');
        logger.warn('Some features will not work without Firebase.');
        logger.warn('To enable Firebase: Follow docs/FIREBASE_SETUP.md');
        logger.warn('═══════════════════════════════════════════════════════');
        return;
      }
    }

    // Initialize Firebase Admin SDK
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
    logger.warn('Continuing in demo mode. Some features will not work.');
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
