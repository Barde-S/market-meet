const { validationResult } = require('express-validator');
const { getFirestore } = require('../config/firebase');
const logger = require('../utils/logger');

const db = () => getFirestore();

async function createBooking(req, res) {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const {
      agentId,
      type,
      title,
      description,
      scheduledDate,
      location,
      locationCoordinates,
      estimatedHours,
      notes,
    } = req.body;

    // Get agent to calculate cost
    const agentDoc = await db().collection('agents').doc(agentId).get();
    if (!agentDoc.exists) {
      return res.status(404).json({ error: 'Agent not found' });
    }

    const agent = agentDoc.data();
    const totalCost = agent.hourlyRate * estimatedHours;

    const bookingData = {
      userId: req.user.uid,
      agentId,
      type,
      status: 'pending',
      title,
      description,
      scheduledDate: new Date(scheduledDate),
      location,
      locationCoordinates: locationCoordinates || null,
      estimatedHours,
      totalCost,
      notes: notes || null,
      createdAt: new Date(),
      updatedAt: new Date(),
    };

    const docRef = await db().collection('bookings').add(bookingData);

    res.status(201).json({
      message: 'Booking created successfully',
      bookingId: docRef.id,
    });
  } catch (error) {
    logger.error('Create booking error:', error);
    res.status(500).json({ error: 'Failed to create booking' });
  }
}

async function getUserBookings(req, res) {
  try {
    const { userId } = req.params;

    // Ensure user can only access their own bookings
    if (userId !== req.user.uid) {
      return res.status(403).json({ error: 'Forbidden' });
    }

    const snapshot = await db()
      .collection('bookings')
      .where('userId', '==', userId)
      .orderBy('createdAt', 'desc')
      .get();

    const bookings = snapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data(),
    }));

    res.status(200).json({ bookings });
  } catch (error) {
    logger.error('Get user bookings error:', error);
    res.status(500).json({ error: 'Failed to fetch bookings' });
  }
}

async function getAgentBookings(req, res) {
  try {
    const { agentId } = req.params;

    const snapshot = await db()
      .collection('bookings')
      .where('agentId', '==', agentId)
      .orderBy('createdAt', 'desc')
      .get();

    const bookings = snapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data(),
    }));

    res.status(200).json({ bookings });
  } catch (error) {
    logger.error('Get agent bookings error:', error);
    res.status(500).json({ error: 'Failed to fetch bookings' });
  }
}

async function getBookingById(req, res) {
  try {
    const { id } = req.params;
    const doc = await db().collection('bookings').doc(id).get();

    if (!doc.exists) {
      return res.status(404).json({ error: 'Booking not found' });
    }

    const booking = doc.data();

    // Ensure user is either the customer or the agent
    if (booking.userId !== req.user.uid && booking.agentId !== req.user.uid) {
      return res.status(403).json({ error: 'Forbidden' });
    }

    res.status(200).json({ id: doc.id, ...booking });
  } catch (error) {
    logger.error('Get booking by ID error:', error);
    res.status(500).json({ error: 'Failed to fetch booking' });
  }
}

async function updateBookingStatus(req, res) {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { id } = req.params;
    const { status } = req.body;

    const doc = await db().collection('bookings').doc(id).get();
    if (!doc.exists) {
      return res.status(404).json({ error: 'Booking not found' });
    }

    await db().collection('bookings').doc(id).update({
      status,
      updatedAt: new Date(),
      ...(status === 'completed' && { completedAt: new Date() }),
    });

    res.status(200).json({ message: 'Booking status updated successfully' });
  } catch (error) {
    logger.error('Update booking status error:', error);
    res.status(500).json({ error: 'Failed to update booking status' });
  }
}

async function cancelBooking(req, res) {
  try {
    const { id } = req.params;

    const doc = await db().collection('bookings').doc(id).get();
    if (!doc.exists) {
      return res.status(404).json({ error: 'Booking not found' });
    }

    const booking = doc.data();
    if (booking.userId !== req.user.uid) {
      return res.status(403).json({ error: 'Forbidden' });
    }

    await db().collection('bookings').doc(id).update({
      status: 'cancelled',
      updatedAt: new Date(),
    });

    res.status(200).json({ message: 'Booking cancelled successfully' });
  } catch (error) {
    logger.error('Cancel booking error:', error);
    res.status(500).json({ error: 'Failed to cancel booking' });
  }
}

module.exports = {
  createBooking,
  getUserBookings,
  getAgentBookings,
  getBookingById,
  updateBookingStatus,
  cancelBooking,
};
