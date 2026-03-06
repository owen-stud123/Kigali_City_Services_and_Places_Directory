import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/listing_model.dart';

class FirestoreService {
  final CollectionReference _listingsCollection = FirebaseFirestore.instance
      .collection('listings');

  // CREATE: Add a new listing
  Future<void> addListing(Listing listing) async {
    await _listingsCollection.add(listing.toMap());
  }

  // READ: Get all listings (Stream for real-time updates)
  Stream<List<Listing>> getListings() {
    return _listingsCollection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => Listing.fromSnapshot(doc)).toList();
        });
  }

  // READ: Get listings by specific user (For "My Listings")
  Stream<List<Listing>> getUserListings(String uid) {
    return _listingsCollection
        .where('createdBy', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
          final listings = snapshot.docs
              .map((doc) => Listing.fromSnapshot(doc))
              .toList();
          // Sort client-side to avoid requiring a Firestore composite index
          listings.sort((a, b) => b.timestamp.compareTo(a.timestamp));
          return listings;
        });
  }

  // UPDATE: Edit an existing listing
  Future<void> updateListing(String id, Map<String, dynamic> data) async {
    await _listingsCollection.doc(id).update(data);
  }

  // DELETE: Remove a listing
  Future<void> deleteListing(String id) async {
    await _listingsCollection.doc(id).delete();
  }
}
