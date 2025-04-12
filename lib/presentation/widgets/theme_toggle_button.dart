import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:mediamosaic/presentation/theme/app_theme.dart';

class ThemeToggleButton extends StatelessWidget {
  final bool mini;

  const ThemeToggleButton({
    super.key,
    this.mini = false,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final brightness = Theme.of(context).brightness;
    
    return mini 
        ? IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: isDarkMode ? Colors.amber : Colors.blueGrey,
            ),
            tooltip: isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
            onPressed: () {
              _toggleTheme(themeProvider);
            },
          )
        : InkWell(
            onTap: () {
              _toggleTheme(themeProvider);
            },
            borderRadius: BorderRadius.circular(30),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isDarkMode 
                    ? Colors.grey[800] 
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    size: 20,
                    color: isDarkMode ? Colors.amber : Colors.blueGrey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isDarkMode ? 'Light Mode' : 'Dark Mode',
                    style: TextStyle(
                      color: brightness == Brightness.dark 
                          ? Colors.white 
                          : Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
  }
  
  void _toggleTheme(ThemeProvider themeProvider) {
    // Provide haptic feedback for better user experience
    HapticFeedback.mediumImpact();
    
    // Toggle the theme
    themeProvider.toggleTheme();
  }
} 