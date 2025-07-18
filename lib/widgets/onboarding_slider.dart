import 'package:flutter/material.dart';

class OnboardingSlider extends StatefulWidget {
  final List<OnboardingSlide> slides;
  final Function()? onSkip;
  final Function()? onDone;

  const OnboardingSlider({
    Key? key,
    required this.slides,
    this.onSkip,
    this.onDone,
  }) : super(key: key);

  @override
  State<OnboardingSlider> createState() => _OnboardingSliderState();
}

class _OnboardingSliderState extends State<OnboardingSlider> {
  int _currentIndex = 0;

  Color _getProgressColor() {
    if (_currentIndex == 0) return Colors.blueAccent; // intro
    if (_currentIndex == widget.slides.length - 1) return Colors.green; // outro
    return Colors.orange; // middle
  }

  @override
  Widget build(BuildContext context) {
    final slide = widget.slides[_currentIndex];
    final isIntro = _currentIndex == 0;
    final isOutro = _currentIndex == widget.slides.length - 1;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Subtitle as tooltip
        if (slide.subtitle != null && slide.subtitle!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Tooltip(
              message: slide.subtitle,
              child: Text(
                slide.subtitle!,
                style: TextStyle(fontSize: 16, color: Colors.grey[700], fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        // Main content
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (slide.image != null)
                  Image.asset(slide.image!, height: 180),
                SizedBox(height: 24),
                Text(
                  slide.title,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                if (slide.description != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Text(
                      slide.description!,
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ),
        // Progress bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (_currentIndex + 1) / widget.slides.length,
              minHeight: 8,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(_getProgressColor()),
            ),
          ),
        ),
        // Navigation buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (isIntro || isOutro)
              TextButton(
                onPressed: widget.onSkip,
                child: Text('Skip', style: TextStyle(color: Colors.redAccent)),
              )
            else
              SizedBox(width: 64),
            Row(
              children: [
                if (_currentIndex > 0)
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      setState(() {
                        _currentIndex--;
                      });
                    },
                  ),
                if (_currentIndex < widget.slides.length - 1)
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      setState(() {
                        _currentIndex++;
                      });
                    },
                  )
                else
                  TextButton(
                    onPressed: widget.onDone,
                    child: Text('Done', style: TextStyle(color: Colors.green)),
                  ),
              ],
            ),
          ],
        ),
        SizedBox(height: 24),
      ],
    );
  }
}

class OnboardingSlide {
  final String title;
  final String? subtitle;
  final String? description;
  final String? image;

  OnboardingSlide({
    required this.title,
    this.subtitle,
    this.description,
    this.image,
  });
}
