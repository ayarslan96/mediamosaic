import 'package:flutter/material.dart';
import 'package:mediamosaic/core/theme/app_theme.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  
  const BottomNavBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppTheme.primaryColor,
          unselectedItemColor: Colors.grey[400],
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              activeIcon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.trending_up),
              label: 'Trending',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star_outline),
              activeIcon: Icon(Icons.star),
              label: 'Featured',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          onTap: (index) {
            if (index == currentIndex) return;
            
            switch (index) {
              case 0:
                // Navigate to Home
                Navigator.pushReplacementNamed(context, '/home');
                break;
              case 1:
                // Navigate to Search
                Navigator.pushReplacementNamed(context, '/search');
                break;
              case 2:
                // Navigate to Trending
                Navigator.pushReplacementNamed(context, '/trending');
                break;
              case 3:
                // Navigate to Featured
                Navigator.pushReplacementNamed(context, '/featured');
                break;
              case 4:
                // Navigate to Profile
                Navigator.pushReplacementNamed(context, '/profile');
                break;
              case 5:
                // Navigate to Chat
                Navigator.pushReplacementNamed(context, '/chat');
                break;
            }
          },
        ),
      ),
    );
  }
} 