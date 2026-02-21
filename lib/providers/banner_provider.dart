import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:knjizara/models/banner_model.dart';

class BannerProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _bannerRef => _firestore.collection('banners');

  Stream<List<BannerItem>> get bannersStream {
    return _bannerRef
        .orderBy('order')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => BannerItem.fromFirestore(doc)).toList());
  }

  // dodavanje
  Future<void> addBanner(BannerItem banner) async {
    await _bannerRef.add(banner.toMap());
  }

  // menjanje
  Future<void> updateBanner(BannerItem banner) async {
    await _bannerRef.doc(banner.id).update(banner.toMap());
  }

  // brisanje
  Future<void> removeBanner(String id) async {
    await _bannerRef.doc(id).delete();
  }

  // aktiviranje
  Future<void> toggleBanner(String id, bool value) async {
    await _bannerRef.doc(id).update({'isActive': value});
  }
}