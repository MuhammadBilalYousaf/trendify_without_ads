import 'package:flutter/material.dart';
import 'package:trendify/models/category_model.dart';
import 'package:trendify/pages/category_news.dart';
import 'package:trendify/pages/bottom_tab_bar.dart';
import 'package:trendify/pages/home.dart'; // Import BottomTabBar

// Categories Page
class CategoriesPage extends StatefulWidget {
  final List<CategoryModel> categories;
  final bool isDarkMode; // Add this line

  CategoriesPage({required this.categories, required this.isDarkMode}); // Update the constructor

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  int _currentIndex = 1; // Index for CategoriesPage in BottomTabBar
  int _selectedTabIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedTabIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: widget.isDarkMode ? ThemeData.dark() : ThemeData.light(), // Apply dark mode
      home: Scaffold(
        appBar: AppBar(
          title: Text('Categories'),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              color: widget.isDarkMode ? Colors.black : Colors.white,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    widget.categories.length,
                    (index) => GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTabIndex = index;
                          _pageController.animateToPage(
                            _selectedTabIndex,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                        margin: EdgeInsets.only(right: 10.0),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 2.0,
                              color: _selectedTabIndex == index ? Colors.blue : Colors.transparent,
                            ),
                          ),
                        ),
                        child: Text(
                          widget.categories[index].categoryName!,
                          style: TextStyle(
                            color: _selectedTabIndex == index ? Colors.blue : widget.isDarkMode ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _selectedTabIndex = index;
                  });
                },
                children: widget.categories
                    .map((category) => CategoryNews(name: category.categoryName!))
                    .toList(),
              ),
            ),
          ],
        ),
        bottomNavigationBar: AnimatedContainer(
          duration: Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: widget.isDarkMode ? Colors.black : Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
          child: BottomTabBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
              if (index == 0) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(),
                  ),
                );
              }
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.category),
                label: 'Categories',
              ),
            ],
            backgroundColor: Colors.transparent,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: true,
            showUnselectedLabels: true,
          ),
        ),
      ),
    );
  }
}
