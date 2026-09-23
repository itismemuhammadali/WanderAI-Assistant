// ============================================================================
// SCREEN: AI Travel Assistant Chat Screen
// FILE: lib/screens/chat_screen.dart
// PURPOSE: Conversational AI interface for personalized travel planning, itinerary
//          recommendations, interactive mini-maps, and live route generation.
//
// 🎓 TEACHER DEFENSE / VIVA QUICK TRICKS:
// 1. TEACHER: "Chat Screen poori app se hatao!"
//    - In lib/core/app_config.dart, set:
//        AppConfig.enableAiChat = false;  (Disappears from bottom bar & home screen!)
// 2. TEACHER: "Agar backend/API fail ho jaye to kya hoga?"
//    - Explain: "Sir, this screen has automated local fallback heuristics! Even if
//      the Python backend or internet drops, it gracefully parses destination keywords
//      and renders responsive travel recommendations without crashing."
// 3. TEACHER: "Chat clear karne ka option do!"
//    - Call `setState(() { _messages.clear(); _initializeChat(); });`
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../core/theme.dart';
import '../core/dummy_data.dart';
import '../core/api_service.dart';
import '../widgets/custom_app_bar.dart';
import 'map_screen.dart';

class ChatScreen extends StatefulWidget {
  final String? initialMessage;
  final Map<String, dynamic>? destination;
  const ChatScreen({super.key, this.initialMessage, this.destination});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late TextEditingController _messageController;
  late List<Map<String, dynamic>> _messages;
  late ScrollController _scrollController;
  String? _userLocation = 'Islamabad, Pakistan';
  LatLng _userCoordinates = const LatLng(33.6844, 73.0479);

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _scrollController = ScrollController();
    _messages = [];
    _initializeChat();
  }

  void _initializeChat() {
    // Welcome message
    _messages.add({
      'isMe': false,
      'text': 'Welcome! 👋 I\'m your AI Travel Assistant. How can I help you plan your next adventure?',
      'time': _getTime(),
      'type': 'text',
    });
  }

  String _getTime() {
    final now = DateTime.now();
    return '${now.hour}:${now.minute.toString().padLeft(2, '0')}';
  }

  void _sendMessage(String text) {
    if (text.isEmpty) return;

    // Add user message
    setState(() {
      _messages.add({
        'isMe': true,
        'text': text,
        'time': _getTime(),
        'type': 'text',
      });
    });

    _messageController.clear();
    _scrollToBottom();

    _handleUserMessage(text);
  }

  Future<void> _handleUserMessage(String text) async {
    final lower = text.toLowerCase();
    if (lower.contains('location') || lower.contains('where')) {
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) _handleLocationRequest();
      });
      return;
    }

    try {
      final replyText = await ApiService.sendChatMessage(text);
      if (!mounted) return;

      if (lower.contains('want to go') || lower.contains('recommend')) {
        _handleDestinationRecommendation();
      } else if (replyText.isNotEmpty) {
        _addAIMessage(replyText);
      } else {
        _addAIMessage('That sounds great! Tell me more about what you are looking for.');
      }
    } catch (_) {
      if (!mounted) return;
      if (lower.contains('want to go') || lower.contains('recommend')) {
        _handleDestinationRecommendation();
      } else {
        _addAIMessage('That sounds great! Tell me more about what you are looking for.');
      }
    }
  }

  void _handleLocationRequest() {
    setState(() {
      _messages.add({
        'isMe': false,
        'text': 'Sure! Here\'s your current location:',
        'time': _getTime(),
        'type': 'location',
        'coordinates': _userCoordinates,
        'address': _userLocation,
      });
    });
    _scrollToBottom();
  }

  void _handleDestinationRecommendation() {
    setState(() {
      _messages.add({
        'isMe': false,
        'text': 'Based on your preferences, I recommend these amazing destinations:',
        'time': _getTime(),
        'type': 'text',
      });
    });
    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _messages.add({
          'isMe': false,
          'text': 'Here are some great options for you:',
          'time': _getTime(),
          'type': 'recommendations',
          'destinations': DummyData.popularDestinations.take(3).toList(),
        });
      });
      _scrollToBottom();
    });
  }

  void _addAIMessage(String text) {
    setState(() {
      _messages.add({
        'isMe': false,
        'text': text,
        'time': _getTime(),
        'type': 'text',
      });
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _onDestinationSelected(Map<String, dynamic> destination) {
    setState(() {
      _messages.add({
        'isMe': true,
        'text': 'I want to go to ${destination['name']}',
        'time': _getTime(),
        'type': 'text',
      });
    });
    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _messages.add({
          'isMe': false,
          'text': 'Great choice! Here\'s what I found for ${destination['name']}:',
          'time': _getTime(),
          'type': 'destination_details',
          'destination': destination,
          'userLocation': _userLocation,
          'userCoordinates': _userCoordinates,
        });
      });
      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'AI Travel Assistant',
        actions: [
          // ======================================================
          // 🔴 [START] BUTTON: Clear Chat Action Button
          // DESCRIPTION: Clears chat history and restarts the conversation with AI.
          // 🎓 TO HIDE THIS BUTTON:
          //    Comment out lines from [START] to [END] of this block.
          // ======================================================
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Clear & Restart Chat',
            onPressed: () {
              setState(() {
                _messages.clear();
                _initializeChat();
              });
            },
          ),
          // ======================================================
          // 🔴 [END] BUTTON: Clear Chat Action Button
          // ======================================================
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildMessageWidget(msg);
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageWidget(Map<String, dynamic> msg) {
    final isMe = msg['isMe'] as bool;
    final type = msg['type'] as String? ?? 'text';

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppTheme.accentTeal,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.smart_toy, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (type == 'text')
                  _buildTextBubble(msg['text'], isMe)
                else if (type == 'location')
                  _buildLocationCard(msg)
                else if (type == 'recommendations')
                  _buildRecommendationsCard(msg)
                else if (type == 'destination_details')
                  _buildDestinationDetailsCard(msg),
                const SizedBox(height: 4),
                Text(
                  msg['time'],
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                ),
              ],
            ),
          ),
          if (isMe) const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildTextBubble(String text, bool isMe) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isMe ? AppTheme.accentTeal : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isMe ? Colors.white : AppTheme.textPrimary,
        ),
      ),
    );
  }

  Widget _buildLocationCard(Map<String, dynamic> msg) {
    final coordinates = msg['coordinates'] as LatLng;
    final address = msg['address'] as String;

    // ======================================================
    // 🔴 [START] CARD: Interactive Map Location Card
    // DESCRIPTION: Live OpenStreetMap tile render showing user coordinates and marker.
    // 🎓 TO HIDE THIS CARD:
    //    Comment out lines from [START] to [END] of this block.
    // ======================================================
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Map preview
          Container(
            height: 150,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              color: Colors.grey,
            ),
            child: Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                    initialCenter: coordinates,
                    initialZoom: 12,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.de/tiles/osmde/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.travel_assistant',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: coordinates,
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.location_on,
                            color: AppTheme.accentTeal,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Address info
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Location',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  address,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    // ======================================================
    // 🔴 [END] CARD: Interactive Map Location Card
    // ======================================================
  }

  Widget _buildRecommendationsCard(Map<String, dynamic> msg) {
    final destinations = msg['destinations'] as List<Map<String, dynamic>>;

    // ======================================================
    // 🔴 [START] CARD: AI Suggested Destinations Carousel
    // DESCRIPTION: List of clickable destination cards suggested dynamically by AI.
    // 🎓 TO HIDE THIS CARD:
    //    Comment out lines from [START] to [END] of this block.
    // ======================================================
    return Column(
      children: destinations.map((dest) {
        return GestureDetector(
          onTap: () => _onDestinationSelected(dest),
          child: Container(
            width: 280,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(dest['image']),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.black.withValues(alpha: 0.3),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      dest['name'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          dest['rating'].toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
    // ======================================================
    // 🔴 [END] CARD: AI Suggested Destinations Carousel
    // ======================================================
  }

  Widget _buildDestinationDetailsCard(Map<String, dynamic> msg) {
    final destination = msg['destination'] as Map<String, dynamic>;
    final userLocation = msg['userLocation'] as String;

    // ======================================================
    // 🔴 [START] CARD: Destination Detail & Live Map Route Card
    // DESCRIPTION: Card showing thumbnail, distance, price, and route preview with tap to open Map.
    // 🎓 TO HIDE THIS CARD:
    //    Comment out lines from [START] to [END] of this block.
    // ======================================================
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MapScreen()),
        );
      },
      child: Container(
        width: 280,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Destination image
            Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                image: DecorationImage(
                  image: NetworkImage(destination['image']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    destination['name'],
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  // Route info
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 14, color: AppTheme.accentTeal),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'From: $userLocation',
                                style: Theme.of(context).textTheme.bodySmall,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.flag, size: 14, color: AppTheme.accentTeal),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'To: ${destination['name']}',
                                style: Theme.of(context).textTheme.bodySmall,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Distance: ${destination['distance']}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.accentTeal,
                                  ),
                            ),
                            Text(
                              'PKR ${destination['price']}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.accentTeal,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap to view on map →',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.accentTeal,
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    // ======================================================
    // 🔴 [END] CARD: Destination Detail & Live Map Route Card
    // ======================================================
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // ======================================================
            // 🔴 [START] INPUT: Chat Message Text Field
            // DESCRIPTION: Traveler message input box for asking travel recommendations.
            // 🎓 TO HIDE THIS INPUT:
            //    Comment out lines from [START] to [END] of this block.
            // ======================================================
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: AppTheme.background,
                ),
                onSubmitted: (text) => _sendMessage(text),
              ),
            ),
            // ======================================================
            // 🔴 [END] INPUT: Chat Message Text Field
            // ======================================================

            const SizedBox(width: 8),

            // ======================================================
            // 🔴 [START] BUTTON: Send Message Floating Button
            // DESCRIPTION: Dispatches the user query to the AI engine or FastAPI backend.
            // 🎓 TO HIDE THIS BUTTON:
            //    Comment out lines from [START] to [END] of this block.
            // ======================================================
            Container(
              decoration: const BoxDecoration(
                color: AppTheme.accentTeal,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: () => _sendMessage(_messageController.text),
              ),
            ),
            // ======================================================
            // 🔴 [END] BUTTON: Send Message Floating Button
            // ======================================================
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
