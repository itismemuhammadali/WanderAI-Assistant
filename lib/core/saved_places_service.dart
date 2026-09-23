import 'package:flutter/material.dart';

class SavedPlacesService extends ChangeNotifier {
  static final SavedPlacesService _instance = SavedPlacesService._internal();

  factory SavedPlacesService() {
    return _instance;
  }

  SavedPlacesService._internal();

  final List<Map<String, dynamic>> _savedPlaces = [];

  List<Map<String, dynamic>> get savedPlaces => _savedPlaces;

  bool isPlaceSaved(String placeId) {
    return _savedPlaces.any((place) => place['id'] == placeId);
  }

  void savePlace(Map<String, dynamic> place) {
    if (!isPlaceSaved(place['id'])) {
      _savedPlaces.add({
        ...place,
        'savedAt': DateTime.now().toString().split(' ')[0],
        'notes': '',
      });
      notifyListeners();
    }
  }

  void removePlace(String placeId) {
    _savedPlaces.removeWhere((place) => place['id'] == placeId);
    notifyListeners();
  }

  void togglePlace(Map<String, dynamic> place) {
    if (isPlaceSaved(place['id'])) {
      removePlace(place['id']);
    } else {
      savePlace(place);
    }
  }

  void updateNotes(String placeId, String notes) {
    final index = _savedPlaces.indexWhere((place) => place['id'] == placeId);
    if (index != -1) {
      _savedPlaces[index]['notes'] = notes;
      notifyListeners();
    }
  }

  Map<String, dynamic>? getPlace(String placeId) {
    try {
      return _savedPlaces.firstWhere((place) => place['id'] == placeId);
    } catch (e) {
      return null;
    }
  }
}
