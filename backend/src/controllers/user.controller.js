const { validationResult } = require('express-validator');
const { getFirestore } = require('../config/firebase');
const logger = require('../utils/logger');

const db = () => getFirestore();

async function getProfile(req, res) {
  try {
    const doc = await db().collection('users').doc(req.user.uid).get();

    if (!doc.exists) {
      return res.status(404).json({ error: 'User not found' });
    }

    res.status(200).json({
      uid: req.user.uid,
      ...doc.data(),
    });
  } catch (error) {
    logger.error('Get profile error:', error);
    res.status(500).json({ error: 'Failed to fetch profile' });
  }
}

async function updateProfile(req, res) {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { name, phoneNumber, preferredLanguages } = req.body;

    const updateData = {
      ...(name && { name }),
      ...(phoneNumber && { phoneNumber }),
      ...(preferredLanguages && { preferredLanguages }),
      updatedAt: new Date(),
    };

    await db().collection('users').doc(req.user.uid).update(updateData);

    res.status(200).json({ message: 'Profile updated successfully' });
  } catch (error) {
    logger.error('Update profile error:', error);
    res.status(500).json({ error: 'Failed to update profile' });
  }
}

async function getUserById(req, res) {
  try {
    const { id } = req.params;
    const doc = await db().collection('users').doc(id).get();

    if (!doc.exists) {
      return res.status(404).json({ error: 'User not found' });
    }

    // Return limited public information
    const userData = doc.data();
    res.status(200).json({
      uid: id,
      name: userData.name,
      // Don't expose sensitive information
    });
  } catch (error) {
    logger.error('Get user by ID error:', error);
    res.status(500).json({ error: 'Failed to fetch user' });
  }
}

module.exports = {
  getProfile,
  updateProfile,
  getUserById,
};
