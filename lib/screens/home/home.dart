import 'package:flutter/material.dart';
import 'package:pixel_art_app/screens/home/drawings.dart';
import 'package:pixel_art_app/screens/home/explore.dart';
import 'package:pixel_art_app/screens/home/profile.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  PageController _pageController;
  AnimationController _animationController;
  Animation<Color> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 1,
      viewportFraction: 1,
      keepPage: false,
    );
    _pageController.addListener(
      () => setState(
        () => _currentPage = _pageController.page.toInt(),
      ),
    );

    _animationController = AnimationController(
      duration: const Duration(
        milliseconds: 300,
      ),
      vsync: this,
    );

    _colorAnimation = ColorTween(
      end: Colors.deepPurple,
    ).animate(_animationController)
      ..addListener(() {
        setState(() => _selectedItemColor = _colorAnimation.value);
      });
  }

  int _currentPage = 1;
  Color _selectedItemColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          Explore(),
          Drawings(),
          Profile(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int _tappedPage) {
          setState(() => _currentPage = _tappedPage);
          _pageController.animateToPage(
            _tappedPage,
            duration: Duration(
              milliseconds: 200,
            ),
            curve: Curves.easeInOut,
          );

          /// _animationController.forward();
        },
        selectedFontSize: 14.0,
        unselectedFontSize: 14.0,
        selectedItemColor: _selectedItemColor,
        currentIndex: _currentPage,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.explore_outlined,
            ),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.image_outlined,
            ),
            label: 'Drawings',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
