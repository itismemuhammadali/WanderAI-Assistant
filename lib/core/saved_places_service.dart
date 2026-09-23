import 'package:flutter/material.dart';

class SavedPlacesService extends ChangeNotifier {
  static final SavedPlacesService _instance = SavedPlacesService._internal();

  factory SavedPlacesService() {
    return _instance;
  }

  SavedPlacesService._internal();

  final List<Map<String, dynamic>> _savedPlaces = [];

  List<Map<String, dynamic>> get savedPlaces => _savedPlaces;

  bool isPlaceSaved(dynamic placeId, [String? placeName]) {
    if (placeId == null && (placeName == null || placeName.isEmpty)) return false;
    final idStr = placeId?.toString();
    return _savedPlaces.any((place) {
      if (idStr != null && idStr.isNotEmpty && place['id']?.toString() == idStr) {
        return true;
      }
      if (placeName != null && placeName.isNotEmpty && place['name']?.toString() == placeName) {
        return true;
      }
      return false;
    });
  }

  void savePlace(Map<String, dynamic> place) {
    final placeId = place['id'];
    final placeName = place['name']?.toString();
    if (!isPlaceSaved(placeId, placeName)) {
      _savedPlaces.add({
        ...place,
        'savedAt': DateTime.now().toString().split(' ')[0],
        'notes': '',
      });
      notifyListeners();
    }
  }

  void removePlace(dynamic placeId, [String? placeName]) {
    final idStr = placeId?.toString();
    _savedPlaces.removeWhere((place) {
      if (idStr != null && idStr.isNotEmpty && place['id']?.toString() == idStr) {
        return true;
      }
      if (placeName != null && placeName.isNotEmpty && place['name']?.toString() == placeName) {
        return true;
      }
      return false;
    });
    notifyListeners();
  }

  void togglePlace(Map<String, dynamic> place) {
    final placeId = place['id'];
    final placeName = place['name']?.toString();
    if (isPlaceSaved(placeId, placeName)) {
      removePlace(placeId, placeName);
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
