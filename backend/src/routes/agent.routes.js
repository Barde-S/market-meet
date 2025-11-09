const express = require('express');
const router = express.Router();
const { body, query } = require('express-validator');
const agentController = require('../controllers/agent.controller');
const { authenticateUser, requireAgent } = require('../middleware/auth');

/**
 * @route   GET /api/agents
 * @desc    Get all verified agents
 * @access  Public
 */
router.get('/', agentController.getAllAgents);

/**
 * @route   GET /api/agents/nearby
 * @desc    Get nearby agents based on location
 * @access  Public
 */
router.get(
  '/nearby',
  [
    query('latitude').isFloat().withMessage('Valid latitude is required'),
    query('longitude').isFloat().withMessage('Valid longitude is required'),
    query('radius').optional().isFloat().withMessage('Radius must be a number'),
  ],
  agentController.getNearbyAgents
);

/**
 * @route   GET /api/agents/:id
 * @desc    Get agent by ID
 * @access  Public
 */
router.get('/:id', agentController.getAgentById);

/**
 * @route   POST /api/agents/profile
 * @desc    Create or update agent profile
 * @access  Private (Agent)
 */
router.post(
  '/profile',
  authenticateUser,
  [
    body('name').notEmpty().withMessage('Name is required'),
    body('phoneNumber').notEmpty().withMessage('Phone number is required'),
    body('bio').notEmpty().withMessage('Bio is required'),
    body('languages').isArray().withMessage('Languages must be an array'),
    body('specialties').isArray().withMessage('Specialties must be an array'),
    body('hourlyRate').isFloat({ min: 0 }).withMessage('Valid hourly rate is required'),
    body('city').notEmpty().withMessage('City is required'),
    body('country').notEmpty().withMessage('Country is required'),
  ],
  agentController.createOrUpdateProfile
);

/**
 * @route   PUT /api/agents/availability
 * @desc    Update agent availability
 * @access  Private (Agent)
 */
router.put(
  '/availability',
  authenticateUser,
  requireAgent,
  [body('available').isBoolean().withMessage('Available must be a boolean')],
  agentController.updateAvailability
);

/**
 * @route   GET /api/agents/:id/reviews
 * @desc    Get agent reviews
 * @access  Public
 */
router.get('/:id/reviews', agentController.getAgentReviews);

module.exports = router;
