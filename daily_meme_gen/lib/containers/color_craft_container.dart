import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/meme_service.dart';

class ColorCraftContainer extends StatefulWidget {
  const ColorCraftContainer({super.key});

  @override
  State<ColorCraftContainer> createState() => _ColorCraftContainerState();
}

class _ColorCraftContainerState extends State<ColorCraftContainer> {
  final MemeService _memeService = MemeService();
  Map<String, dynamic>? _currentMeme;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadMemeOfTheDay();
  }

  Future<void> _loadMemeOfTheDay() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final meme = await _memeService.getMemeOfTheDay();
      setState(() {
        _currentMeme = meme;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadRandomMeme() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final meme = await _memeService.getRandomMeme();
      setState(() {
        _currentMeme = meme;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DailyMemeGen'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_error != null)
              Center(
                child: Column(
                  children: [
                    Text(
                      'Error: $_error',
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadMemeOfTheDay,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
            else if (_currentMeme != null)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _currentMeme!['title'] ?? 'Untitled Meme',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: _currentMeme!['url'],
                          fit: BoxFit.contain,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadRandomMeme,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: const Text(
                'Generate Random Meme',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
