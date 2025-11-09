const express = require('express');
const router = express.Router();
const { body, param } = require('express-validator');
const bookingController = require('../controllers/booking.controller');
const { authenticateUser } = require('../middleware/auth');

/**
 * @route   POST /api/bookings
 * @desc    Create a new booking
 * @access  Private
 */
router.post(
  '/',
  authenticateUser,
  [
    body('agentId').notEmpty().withMessage('Agent ID is required'),
    body('type').isIn(['escort', 'search', 'purchase', 'translation'])
      .withMessage('Invalid booking type'),
    body('title').notEmpty().withMessage('Title is required'),
    body('description').notEmpty().withMessage('Description is required'),
    body('scheduledDate').isISO8601().withMessage('Valid date is required'),
    body('location').notEmpty().withMessage('Location is required'),
    body('estimatedHours').isFloat({ min: 0.5 })
      .withMessage('Estimated hours must be at least 0.5'),
  ],
  bookingController.createBooking
);

/**
 * @route   GET /api/bookings/user/:userId
 * @desc    Get all bookings for a user
 * @access  Private
 */
router.get('/user/:userId', authenticateUser, bookingController.getUserBookings);

/**
 * @route   GET /api/bookings/agent/:agentId
 * @desc    Get all bookings for an agent
 * @access  Private
 */
router.get('/agent/:agentId', authenticateUser, bookingController.getAgentBookings);

/**
 * @route   GET /api/bookings/:id
 * @desc    Get booking by ID
 * @access  Private
 */
router.get('/:id', authenticateUser, bookingController.getBookingById);

/**
 * @route   PUT /api/bookings/:id/status
 * @desc    Update booking status
 * @access  Private
 */
router.put(
  '/:id/status',
  authenticateUser,
  [
    param('id').notEmpty().withMessage('Booking ID is required'),
    body('status').isIn(['pending', 'confirmed', 'inProgress', 'completed', 'cancelled'])
      .withMessage('Invalid status'),
  ],
  bookingController.updateBookingStatus
);

/**
 * @route   DELETE /api/bookings/:id
 * @desc    Cancel booking
 * @access  Private
 */
router.delete('/:id', authenticateUser, bookingController.cancelBooking);

module.exports = router;
