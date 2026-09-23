import 'package:flutter/material.dart';

class TravelHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Widget? trailing;

  const TravelHeader({
    super.key,
    required this.title,
    this.subtitle = '',
    this.showBackButton = false,
    this.onBackPressed,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade800,
            Colors.lightBlue.shade600,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (showBackButton)
                  IconButton(
                    onPressed: onBackPressed ?? () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                    splashRadius: 20,
                  )
                else
                  const SizedBox(width: 48),
                
                // Center title or logo
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.flight_takeoff_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Travel Assistant',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Trailing widget or placeholder
                trailing ?? const SizedBox(width: 48),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Main title
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w800,
                height: 1.2,
              ),
            ),
            
            if (subtitle.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}