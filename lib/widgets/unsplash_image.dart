import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UnsplashImage extends StatefulWidget {
  final String query;
  final String? fallbackUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const UnsplashImage({
    super.key,
    required this.query,
    this.fallbackUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  State<UnsplashImage> createState() => _UnsplashImageState();
}

class _UnsplashImageState extends State<UnsplashImage> {
  late Future<String> _imageUrlFuture;
  static const String _accessKey = 'qJvMMjqnEvmLohmnhULLisAno-sucQVhQnPzz_Hy3lE';
  static const String _baseUrl = 'https://api.unsplash.com/search/photos';
  static final Map<String, String> _imageCache = {};

  static const String _defaultScenicBackup =
      'https://images.unsplash.com/photo-1514558427911-8e293bebf18c?q=80&w=1080&auto=format&fit=crop'; // Hunza Valley

  // Verified landmark photography for authentic Pakistani locations
  static final Map<String, String> _verifiedLandmarks = {
    'islamabad': 'https://images.unsplash.com/photo-1608020932658-d0e19a69580b?q=80&w=1080&auto=format&fit=crop', // Faisal Mosque
    'lahore': 'https://images.unsplash.com/photo-1622546758596-f1f06ba11f58?q=80&w=1080&auto=format&fit=crop', // Minar-e-Pakistan & Badshahi Mosque
    'naran': 'https://images.unsplash.com/photo-1668061867899-02b4cfa34747?q=80&w=1080&auto=format&fit=crop', // Naran Kaghan
    'kaghan': 'https://images.unsplash.com/photo-1668061867899-02b4cfa34747?q=80&w=1080&auto=format&fit=crop',
    'saiful malook': 'https://images.unsplash.com/photo-1626685516371-a0ee93a0f370?q=80&w=1080&auto=format&fit=crop', // Lake Saif-ul-Malook
    'saif-ul-malook': 'https://images.unsplash.com/photo-1626685516371-a0ee93a0f370?q=80&w=1080&auto=format&fit=crop',
    'saiful muluk': 'https://images.unsplash.com/photo-1626685516371-a0ee93a0f370?q=80&w=1080&auto=format&fit=crop',
    'hunza': 'https://images.unsplash.com/photo-1514558427911-8e293bebf18c?q=80&w=1080&auto=format&fit=crop', // Hunza Valley
    'skardu': 'https://images.unsplash.com/photo-1679951124125-50cc4029d727?q=80&w=1080&auto=format&fit=crop', // Skardu Shangrila Lake
    'swat': 'https://images.unsplash.com/photo-1668936782695-5f7657dc793d?q=80&w=1080&auto=format&fit=crop', // Kalam Swat Valley
    'fairy meadows': 'https://images.unsplash.com/photo-1664872763520-348c1cbbade4?q=80&w=1080&auto=format&fit=crop', // Fairy Meadows Nanga Parbat
    'babusar': 'https://images.unsplash.com/photo-1627894483216-2138af692e32?q=80&w=1080&auto=format&fit=crop',
    'attabad': 'https://images.unsplash.com/photo-1612128952123-88ed13410495?q=80&w=1080&auto=format&fit=crop',
    'taxila': 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?q=80&w=1080&auto=format&fit=crop',
    'nathia gali': 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?q=80&w=1080&auto=format&fit=crop',
    'rohtas': 'https://images.unsplash.com/photo-1564507592333-c60657eea523?q=80&w=1080&auto=format&fit=crop',
    'churna': 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?q=80&w=1080&auto=format&fit=crop',
    'kumrat': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?q=80&w=1080&auto=format&fit=crop',
    'neelum': 'https://images.unsplash.com/photo-1534447677768-be436bb09401?q=80&w=1080&auto=format&fit=crop',
    'ratti gali': 'https://images.unsplash.com/photo-1534447677768-be436bb09401?q=80&w=1080&auto=format&fit=crop',
    'shogran': 'https://images.unsplash.com/photo-1627894483216-2138af692e32?q=80&w=1080&auto=format&fit=crop',
    'kalash': 'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?q=80&w=1080&auto=format&fit=crop',
    'deosai': 'https://images.unsplash.com/photo-1426604966848-d7adac402bff?q=80&w=1080&auto=format&fit=crop',
    'khunjerab': 'https://images.unsplash.com/photo-1426604966848-d7adac402bff?q=80&w=1080&auto=format&fit=crop',
    'cholistan': 'https://images.unsplash.com/photo-1509316975850-ff9c5deb0cd9?q=80&w=1080&auto=format&fit=crop',
    'kund malir': 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=1080&auto=format&fit=crop',
    'gorakh': 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?q=80&w=1080&auto=format&fit=crop',
    'ziarat': 'https://images.unsplash.com/photo-1448375240586-882707db888b?q=80&w=1080&auto=format&fit=crop',
    'astola': 'https://images.unsplash.com/photo-1518837695005-2083093ee35b?q=80&w=1080&auto=format&fit=crop',
    'kalam': 'https://images.unsplash.com/photo-1668936782695-5f7657dc793d?q=80&w=1080&auto=format&fit=crop',

  };


  @override
  void initState() {
    super.initState();
    _imageUrlFuture = _fetchImageUrl();
  }

  @override
  void didUpdateWidget(UnsplashImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.query != widget.query || oldWidget.fallbackUrl != widget.fallbackUrl) {
      _imageUrlFuture = _fetchImageUrl();
    }
  }

  String _cleanScenicQuery(String raw) {
    final clean = raw.trim();
    final lower = clean.toLowerCase();

    if (lower.contains('hunza')) return 'Hunza valley mountains landscape';
    if (lower.contains('skardu')) return 'Skardu lake Karakoram mountains';
    if (lower.contains('swat')) return 'Swat valley river landscape nature';
    if (lower.contains('fairy meadows')) return 'Fairy Meadows Nanga Parbat mountain landscape';
    if (lower.contains('naran')) return 'Saif ul Malook Lake Naran landscape';
    if (lower.contains('neelum')) return 'Neelum valley Azad Kashmir river landscape';
    if (lower.contains('kallar kahar')) return 'Kallar Kahar lake scenic nature';
    if (lower.contains('babusar')) return 'Babusar Top mountain pass panoramic landscape';
    if (lower.contains('lulusar')) return 'Lulusar lake mountain alpine landscape';
    if (lower.contains('lahore')) return 'Minar e Pakistan Lahore';
    if (lower.contains('islamabad')) return 'Faisal Mosque Islamabad';

    if (lower.contains('landscape') || lower.contains('mountain') || lower.contains('lake')) {
      return '$clean Pakistan';
    }
    return '$clean Pakistan scenic landscape tourism';
  }

  Future<String> _fetchImageUrl() async {
    // 1. Explicit fallbackUrl priority
    if (widget.fallbackUrl != null && widget.fallbackUrl!.isNotEmpty) {
      _imageCache[widget.query] = widget.fallbackUrl!;
      return widget.fallbackUrl!;
    }

    // 2. Check verified landmark database
    final lowerQuery = widget.query.toLowerCase();
    for (final entry in _verifiedLandmarks.entries) {
      if (lowerQuery.contains(entry.key)) {
        _imageCache[widget.query] = entry.value;
        return entry.value;
      }
    }

    try {
      final searchQuery = _cleanScenicQuery(widget.query);

      // Check cache first
      if (_imageCache.containsKey(searchQuery)) {
        return _imageCache[searchQuery]!;
      }

      final url = Uri.parse(
        '$_baseUrl?query=${Uri.encodeComponent(searchQuery)}&per_page=1&client_id=$_accessKey',
      );

      final response = await http.get(url).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final results = json['results'] as List;

        if (results.isNotEmpty) {
          final imageUrl = results[0]['urls']['regular'] as String;
          _imageCache[searchQuery] = imageUrl;
          return imageUrl;
        }
      }

      if (widget.fallbackUrl != null && widget.fallbackUrl!.isNotEmpty) {
        return widget.fallbackUrl!;
      }
      return _defaultScenicBackup;
    } catch (e) {
      debugPrint('Error fetching image for ${widget.query}: $e');
      if (widget.fallbackUrl != null && widget.fallbackUrl!.isNotEmpty) {
        return widget.fallbackUrl!;
      }
      return _defaultScenicBackup;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _imageUrlFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildPlaceholder();
        }

        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return _buildImage(snapshot.data!);
        }

        if (widget.fallbackUrl != null && widget.fallbackUrl!.isNotEmpty) {
          return _buildImage(widget.fallbackUrl!);
        }

        return _buildImage(_defaultScenicBackup);
      },
    );
  }

  Widget _buildImage(String imageUrl) {
    final image = Image.network(
      imageUrl,
      fit: widget.fit,
      width: widget.width,
      height: widget.height,
      errorBuilder: (context, error, stackTrace) {
        return Image.network(
          _defaultScenicBackup,
          fit: widget.fit,
          width: widget.width,
          height: widget.height,
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return _buildPlaceholder();
      },
    );

    if (widget.borderRadius != null) {
      return ClipRRect(
        borderRadius: widget.borderRadius!,
        child: image,
      );
    }

    return image;
  }

  Widget _buildPlaceholder() {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: widget.borderRadius,
      ),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade600),
          ),
        ),
      ),
    );
  }
}
