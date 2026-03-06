import 'package:flutter/material.dart';
import '../models/listing_model.dart';
import '../services/firestore_service.dart';

class ListingProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  // Categories for filtering
  final List<String> categories = [
    'All',
    'Hospital',
    'Police Station',
    'Library',
    'Restaurant',
    'Café',
    'Park',
    'Tourist Attraction',
    'Other',
  ];

  String _selectedCategory = 'All';
  String _searchQuery = '';

  // Getters
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  // Setters
  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // CRUD Operations exposed to UI
  Future<void> addListing(Listing listing) async {
    await _firestoreService.addListing(listing);
  }

  Future<void> updateListing(String id, Map<String, dynamic> data) async {
    await _firestoreService.updateListing(id, data);
  }

  Future<void> deleteListing(String id) async {
    await _firestoreService.deleteListing(id);
  }

  // Stream of listings (Filtered by Category and Search)
  Stream<List<Listing>> get listingsStream {
    return _firestoreService.getListings().map((listings) {
      return listings.where((listing) {
        // Filter by Category
        final matchesCategory =
            _selectedCategory == 'All' || listing.category == _selectedCategory;

        // Filter by Search Query (Name or Address)
        final matchesSearch =
            listing.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            listing.address.toLowerCase().contains(_searchQuery.toLowerCase());

        return matchesCategory && matchesSearch;
      }).toList();
    });
  }

  // Stream for "My Listings"
  Stream<List<Listing>> userListingsStream(String uid) {
    return _firestoreService.getUserListings(uid);
  }
}
