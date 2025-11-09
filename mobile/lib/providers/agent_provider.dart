import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/agent.dart';

class AgentProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Agent> _agents = [];
  List<Agent> _nearbyAgents = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Agent> get agents => _agents;
  List<Agent> get nearbyAgents => _nearbyAgents;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Fetch all verified agents
  Future<void> fetchAgents() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final QuerySnapshot snapshot = await _firestore
          .collection('agents')
          .where('verified', isEqualTo: true)
          .where('available', isEqualTo: true)
          .get();

      _agents = snapshot.docs
          .map((doc) => Agent.fromFirestore(doc))
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Fetch nearby agents based on location
  Future<void> fetchNearbyAgents(double latitude, double longitude, double radiusKm) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // TODO: Implement geohash or geo-query for efficient location-based search
      // For now, fetching all agents and filtering client-side (not production-ready)
      await fetchAgents();

      // Filter agents within radius (basic implementation)
      // In production, use GeoFirestore or similar for efficient geo-queries
      _nearbyAgents = _agents; // Placeholder

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Get agent by ID
  Future<Agent?> getAgentById(String agentId) async {
    try {
      final DocumentSnapshot doc = await _firestore
          .collection('agents')
          .doc(agentId)
          .get();

      if (doc.exists) {
        return Agent.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }
}
