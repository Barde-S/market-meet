const { verifyToken } = require('../config/firebase');
const logger = require('../utils/logger');

/**
 * Middleware to verify Firebase authentication token
 */
async function authenticateUser(req, res, next) {
  try {
    // Get token from header
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({
        error: 'Unauthorized',
        message: 'No authentication token provided',
      });
    }

    // Extract token
    const idToken = authHeader.split('Bearer ')[1];

    // Verify token
    const decodedToken = await verifyToken(idToken);

    // Attach user info to request
    req.user = {
      uid: decodedToken.uid,
      email: decodedToken.email,
      emailVerified: decodedToken.email_verified,
    };

    next();
  } catch (error) {
    logger.error('Authentication error:', error);
    return res.status(401).json({
      error: 'Unauthorized',
      message: 'Invalid or expired token',
    });
  }
}

/**
 * Middleware to check if user is an agent
 */
async function requireAgent(req, res, next) {
  try {
    const { getFirestore } = require('../config/firebase');
    const db = getFirestore();

    // Check if user is an agent
    const agentDoc = await db.collection('agents').doc(req.user.uid).get();

    if (!agentDoc.exists) {
      return res.status(403).json({
        error: 'Forbidden',
        message: 'Agent access required',
      });
    }

    req.agent = agentDoc.data();
    next();
  } catch (error) {
    logger.error('Agent verification error:', error);
    return res.status(500).json({
      error: 'Internal Server Error',
      message: 'Error verifying agent status',
    });
  }
}

module.exports = {
  authenticateUser,
  requireAgent,
};
