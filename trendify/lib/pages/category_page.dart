import 'package:flutter/material.dart';
import 'package:trendify/models/category_model.dart';
import 'package:trendify/pages/category_news.dart';
import 'package:trendify/pages/contact_page.dart';
import 'package:trendify/pages/home.dart';

class CategoriesPage extends StatefulWidget {
  final List<CategoryModel> categories;

  CategoriesPage({required this.categories});

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  int _currentIndex = 1;
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
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Categories',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              color: Colors.black,
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
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        margin: EdgeInsets.only(right: 10.0),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 2.0,
                              color: _selectedTabIndex == index
                                  ? Colors.blue
                                  : Colors.transparent,
                            ),
                          ),
                        ),
                        child: Text(
                          widget.categories[index].categoryName!,
                          style: TextStyle(
                            color: _selectedTabIndex == index
                                ? Colors.blue
                                : Colors.white,
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
                    .map((category) =>
                        CategoryNews(name: category.categoryName!))
                    .toList(),
              ),
            ),
          ],
        ),
        bottomNavigationBar: AnimatedContainer(
          duration: Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
              if (index == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(),
                  ),
                );
              } else if (index == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContactPage(),
                  ),
                );
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.category),
                label: 'Categories',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.contact_page),
                label: 'Contact',
              ),
            ],
            backgroundColor: Colors.white,
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
