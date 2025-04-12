import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mediamosaic/firebase_options.dart';
import 'package:mediamosaic/data/models/media_content_model.dart';
import 'package:mediamosaic/data/services/auth_service.dart';
import 'package:mediamosaic/presentation/screens/auth/login_screen.dart';
import 'package:mediamosaic/presentation/screens/auth/register_screen.dart';
import 'package:mediamosaic/presentation/screens/home_screen.dart';
import 'package:mediamosaic/presentation/screens/media_detail_screen.dart';
import 'package:mediamosaic/presentation/screens/personalization_survey_screen.dart';
import 'package:mediamosaic/presentation/screens/profile_screen.dart';
import 'package:mediamosaic/presentation/screens/search_screen.dart';
import 'package:mediamosaic/presentation/screens/trending_screen.dart';
import 'package:mediamosaic/presentation/screens/chat/chat_list_screen.dart';
import 'package:mediamosaic/presentation/screens/chat/friend_search_screen.dart';
import 'package:mediamosaic/presentation/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  
  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
        Provider<AuthService>(
          create: (context) => FirebaseAuthService(),
        ),
      ],
      child: const MediaMosaicApp(),
    ),
  );
}

class MediaMosaicApp extends StatelessWidget {
  const MediaMosaicApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return MaterialApp(
      title: 'MediaMosaic',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      initialRoute: '/home',
      onGenerateRoute: (settings) {
        if (settings.name == '/login') {
          return MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          );
        } else if (settings.name == '/register') {
          return MaterialPageRoute(
            builder: (context) => const RegisterScreen(),
          );
        } else if (settings.name == '/home') {
          return MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          );
        } else if (settings.name == '/search') {
          return MaterialPageRoute(
            builder: (context) => const SearchScreen(),
          );
        } else if (settings.name == '/trending') {
          return MaterialPageRoute(
            builder: (context) => const TrendingScreen(),
          );
        } else if (settings.name == '/profile') {
          return MaterialPageRoute(
            builder: (context) => const ProfileScreen(),
          );
        } else if (settings.name == '/personalization') {
          return MaterialPageRoute(
            builder: (context) => const PersonalizationSurveyScreen(),
          );
        } else if (settings.name == '/detail') {
          final MediaContent mediaContent = settings.arguments as MediaContent;
          return MaterialPageRoute(
            builder: (context) => MediaDetailScreen(
              mediaContent: mediaContent,
            ),
          );
        } else if (settings.name == '/chat') {
          return MaterialPageRoute(
            builder: (context) => const ChatListScreen(),
          );
        } else if (settings.name == '/friend_search') {
          return MaterialPageRoute(
            builder: (context) => const FriendSearchScreen(),
          );
        }
        
        // Default fallback route
        return MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        );
      },
    );
  }
}
