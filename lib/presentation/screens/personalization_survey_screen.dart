import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mediamosaic/presentation/theme/app_theme.dart';
import 'package:mediamosaic/presentation/screens/home_screen.dart';

class PersonalizationSurveyScreen extends StatefulWidget {
  const PersonalizationSurveyScreen({super.key});

  @override
  State<PersonalizationSurveyScreen> createState() => _PersonalizationSurveyScreenState();
}

class _PersonalizationSurveyScreenState extends State<PersonalizationSurveyScreen> with SingleTickerProviderStateMixin {
  int _currentStep = 0;
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  // Survey responses
  final Set<String> _selectedCategories = {};
  final Set<String> _selectedContentTypes = {};
  final Set<String> _selectedTopics = {};
  String _contentFrequency = 'Daily';
  
  // Available options
  final List<String> _categories = [
    'Technology', 'Entertainment', 'Sports', 'Politics', 
    'Science', 'Health', 'Travel', 'Food', 'Fashion',
    'Business', 'Education', 'Art', 'Music', 'Gaming',
  ];
  
  final List<String> _contentTypes = [
    'News Articles', 'Videos', 'Podcasts', 'Memes',
    'Tweets', 'Blog Posts', 'Infographics', 'Tutorials',
  ];
  
  final List<String> _topics = [
    'Software Development', 'Artificial Intelligence', 'Space Exploration',
    'Climate Change', 'Renewable Energy', 'Electric Vehicles',
    'Cryptocurrencies', 'Startups', 'Remote Work',
    'Mental Health', 'Fitness', 'Nutrition',
    'Movies', 'TV Shows', 'Music',
    'Mobile Devices', 'Smart Home', 'Wearables',
  ];
  
  final List<String> _frequencies = [
    'Multiple times a day', 'Daily', 'A few times a week', 'Weekly', 'Less often'
  ];
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn)
    );
    
    _slideAnimation = Tween<Offset>(begin: const Offset(0.25, 0.0), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutQuad)
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  Future<void> _completeOnboarding() async {
    setState(() {
      _isLoading = true;
    });
    
    // Provide haptic feedback
    HapticFeedback.mediumImpact();
    
    try {
      // Simulate API call to save preferences
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save preferences: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  void _nextStep() {
    // Validate current step
    if (_currentStep == 0 && _selectedCategories.isEmpty) {
      _showValidationError('Please select at least one category.');
      return;
    } else if (_currentStep == 1 && _selectedContentTypes.isEmpty) {
      _showValidationError('Please select at least one content type.');
      return;
    } else if (_currentStep == 2 && _selectedTopics.isEmpty) {
      _showValidationError('Please select at least one topic.');
      return;
    }
    
    // Provide haptic feedback
    HapticFeedback.selectionClick();
    
    // Animate out current step
    _animationController.reverse().then((_) {
      setState(() {
        _currentStep += 1;
      });
      
      // Animate in next step
      _animationController.forward();
    });
  }
  
  void _previousStep() {
    // Provide haptic feedback
    HapticFeedback.selectionClick();
    
    // Animate out current step
    _animationController.reverse().then((_) {
      setState(() {
        _currentStep -= 1;
      });
      
      // Animate in previous step
      _animationController.forward();
    });
  }
  
  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personalize Your Experience'),
        automaticallyImplyLeading: _currentStep > 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stepper(
              currentStep: _currentStep,
              type: StepperType.horizontal,
              controlsBuilder: (context, details) {
                return Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                      if (_currentStep > 0)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _previousStep,
                            child: const Text('Back'),
                          ),
                        ),
                      if (_currentStep > 0)
                        const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _currentStep < 3 ? _nextStep : _completeOnboarding,
                          child: Text(_currentStep < 3 ? 'Next' : 'Finish'),
                        ),
                      ),
                    ],
                  ),
                );
              },
              steps: [
                Step(
                  title: const Text('Categories'),
                  content: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: _buildCategoriesStep(),
                    ),
                  ),
                  isActive: _currentStep >= 0,
                  state: _currentStep > 0 ? StepState.complete : StepState.indexed,
                ),
                Step(
                  title: const Text('Content Types'),
                  content: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: _buildContentTypesStep(),
                    ),
                  ),
                  isActive: _currentStep >= 1,
                  state: _currentStep > 1 ? StepState.complete : StepState.indexed,
                ),
                Step(
                  title: const Text('Topics'),
                  content: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: _buildTopicsStep(),
                    ),
                  ),
                  isActive: _currentStep >= 2,
                  state: _currentStep > 2 ? StepState.complete : StepState.indexed,
                ),
                Step(
                  title: const Text('Frequency'),
                  content: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: _buildFrequencyStep(),
                    ),
                  ),
                  isActive: _currentStep >= 3,
                  state: _currentStep > 3 ? StepState.complete : StepState.indexed,
                ),
              ],
            ),
    );
  }
  
  Widget _buildCategoriesStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What categories interest you?',
          style: AppTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          'Select categories to personalize your feed.',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _categories.map((category) {
            final isSelected = _selectedCategories.contains(category);
            return FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedCategories.add(category);
                  } else {
                    _selectedCategories.remove(category);
                  }
                });
              },
              backgroundColor: Colors.grey[200],
              selectedColor: AppTheme.primaryColor.withOpacity(0.2),
              checkmarkColor: AppTheme.primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? AppTheme.primaryColor : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        Text(
          'Selected: ${_selectedCategories.length} of ${_categories.length}',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
  
  Widget _buildContentTypesStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What types of content do you prefer?',
          style: AppTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          'Select the content formats you enjoy most.',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _contentTypes.map((type) {
            final isSelected = _selectedContentTypes.contains(type);
            return FilterChip(
              label: Text(type),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedContentTypes.add(type);
                  } else {
                    _selectedContentTypes.remove(type);
                  }
                });
              },
              backgroundColor: Colors.grey[200],
              selectedColor: AppTheme.secondaryColor.withOpacity(0.2),
              checkmarkColor: AppTheme.secondaryColor,
              labelStyle: TextStyle(
                color: isSelected ? AppTheme.secondaryColor : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        Text(
          'Selected: ${_selectedContentTypes.length} of ${_contentTypes.length}',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
  
  Widget _buildTopicsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What specific topics interest you?',
          style: AppTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          'Select topics to see more content about them.',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _topics.map((topic) {
            final isSelected = _selectedTopics.contains(topic);
            return FilterChip(
              label: Text(topic),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedTopics.add(topic);
                  } else {
                    _selectedTopics.remove(topic);
                  }
                });
              },
              backgroundColor: Colors.grey[200],
              selectedColor: AppTheme.accentColor.withOpacity(0.2),
              checkmarkColor: AppTheme.accentColor,
              labelStyle: TextStyle(
                color: isSelected ? AppTheme.accentColor : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        Text(
          'Selected: ${_selectedTopics.length} of ${_topics.length}',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
  
  Widget _buildFrequencyStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How often would you like to receive updates?',
          style: AppTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          'We\'ll use this to determine how often to refresh your feed.',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 24),
        ...List.generate(_frequencies.length, (index) {
          final frequency = _frequencies[index];
          return RadioListTile<String>(
            title: Text(frequency),
            value: frequency,
            groupValue: _contentFrequency,
            onChanged: (value) {
              setState(() {
                _contentFrequency = value!;
              });
            },
            activeColor: AppTheme.primaryColor,
            contentPadding: EdgeInsets.zero,
          );
        }),
        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 16),
        Text(
          'Almost done!',
          style: AppTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'Once you complete the survey, we\'ll personalize your content feed based on your preferences. You can always change these settings later in your profile.',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ],
    );
  }
} 