const { validationResult } = require('express-validator');
const { getFirestore } = require('../config/firebase');
const logger = require('../utils/logger');

const db = () => getFirestore();

async function getAllAgents(req, res) {
  try {
    const snapshot = await db()
      .collection('agents')
      .where('verified', '==', true)
      .where('available', '==', true)
      .get();

    const agents = snapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data(),
    }));

    res.status(200).json({ agents });
  } catch (error) {
    logger.error('Get all agents error:', error);
    res.status(500).json({ error: 'Failed to fetch agents' });
  }
}

async function getNearbyAgents(req, res) {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { latitude, longitude, radius = 10 } = req.query;

    // TODO: Implement geohash-based location query
    // For now, returning all agents (placeholder)
    const snapshot = await db()
      .collection('agents')
      .where('verified', '==', true)
      .where('available', '==', true)
      .get();

    const agents = snapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data(),
    }));

    res.status(200).json({ agents });
  } catch (error) {
    logger.error('Get nearby agents error:', error);
    res.status(500).json({ error: 'Failed to fetch nearby agents' });
  }
}

async function getAgentById(req, res) {
  try {
    const { id } = req.params;
    const doc = await db().collection('agents').doc(id).get();

    if (!doc.exists) {
      return res.status(404).json({ error: 'Agent not found' });
    }

    res.status(200).json({ id: doc.id, ...doc.data() });
  } catch (error) {
    logger.error('Get agent by ID error:', error);
    res.status(500).json({ error: 'Failed to fetch agent' });
  }
}

async function createOrUpdateProfile(req, res) {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { name, phoneNumber, bio, languages, specialties, hourlyRate, city, country } = req.body;

    const agentData = {
      name,
      phoneNumber,
      bio,
      languages,
      specialties,
      hourlyRate,
      city,
      country,
      email: req.user.email,
      verified: false, // Admin verification required
      available: true,
      rating: 0,
      totalReviews: 0,
      updatedAt: new Date(),
    };

    await db().collection('agents').doc(req.user.uid).set(agentData, { merge: true });

    res.status(200).json({ message: 'Agent profile updated successfully' });
  } catch (error) {
    logger.error('Create/update agent profile error:', error);
    res.status(500).json({ error: 'Failed to update agent profile' });
  }
}

async function updateAvailability(req, res) {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { available } = req.body;

    await db().collection('agents').doc(req.user.uid).update({
      available,
      updatedAt: new Date(),
    });

    res.status(200).json({ message: 'Availability updated successfully' });
  } catch (error) {
    logger.error('Update availability error:', error);
    res.status(500).json({ error: 'Failed to update availability' });
  }
}

async function getAgentReviews(req, res) {
  try {
    const { id } = req.params;

    const snapshot = await db()
      .collection('reviews')
      .where('agentId', '==', id)
      .orderBy('createdAt', 'desc')
      .get();

    const reviews = snapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data(),
    }));

    res.status(200).json({ reviews });
  } catch (error) {
    logger.error('Get agent reviews error:', error);
    res.status(500).json({ error: 'Failed to fetch reviews' });
  }
}

module.exports = {
  getAllAgents,
  getNearbyAgents,
  getAgentById,
  createOrUpdateProfile,
  updateAvailability,
  getAgentReviews,
};
