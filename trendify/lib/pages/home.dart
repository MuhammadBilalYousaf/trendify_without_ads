import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:trendify/pages/all_news.dart';
import 'package:trendify/pages/article_view.dart';
import 'package:trendify/pages/category_news.dart';
import 'package:trendify/pages/category_page.dart';
import 'package:trendify/services/data.dart';
import 'package:trendify/services/News.dart';
import 'package:trendify/models/category_model.dart';
import 'package:trendify/models/article_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:trendify/models/slider_model.dart';
import 'package:trendify/services/slider_data.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'landing_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:trendify/pages/bottom_tab_bar.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    ));

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categories = [];
  List<SliderModel> sliders = [];
  List<ArticleModel> articles = [];
  bool _loading = true;
  bool isDarkMode = false; // Track dark mode state

  int activeIndex = 0;
  int _currentIndex = 0;

  // Lists for dropdown menus
  List<String> countryList = ['us', 'in', 'uk', 'au', 'ca'];
  List<String> categoryList = ['business', 'entertainment', 'general', 'health', 'science', 'sports', 'technology'];
  String selectedCountry = 'us';
  String selectedCategory = 'business';

  @override
  void initState() {
  categories = getCategories();
  fetchData(); // Call a method to fetch both slider and news data
  super.initState();
}

fetchData() async {
  await getSlider(); // Wait for getSlider() to complete
  await getNews();   // Wait for getNews() to complete
  setState(() {
    _loading = false;
  });
}

  getNews() async {
    News newsclass = News();
    await newsclass.getNews();
    articles = newsclass.news;

    setState(() {
      _loading = false;
    });
  }

  getSlider() async {
    Sliders slider = Sliders();
    await slider.getSlider(selectedCountry,selectedCategory);
    sliders = slider.sliders;

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('TREND'),
              Text(
                'ify',
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Column(
                        children: [
                          Container(
                              margin: const EdgeInsets.only(left: 10.0),
                              height: 70,
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: categories.length,
                                itemBuilder: (context, index) {
                                  return CategoryTile(
                                    // image: categories[index].image!,
                                    categoryName:
                                        categories[index].categoryName!,
                                  );
                                },
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                                               // Dropdowns for selecting country and category
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              DropdownButton<String>(
                                value: selectedCountry,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedCountry = newValue!;
                                    fetchData(); // Fetch new data based on selection
                                  });
                                },
                                items: countryList.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value.toUpperCase()),
                                  );
                                }).toList(),
                              ),
                              DropdownButton<String>(
                                value: selectedCategory,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedCategory = newValue!;
                                    fetchData(); // Fetch new data based on selection
                                  });
                                },
                                items: categoryList.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value.toLowerCase()),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        const SizedBox(
                      height: 15.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Breaking News",
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              fontFamily: 'SedgwickAveDisplay_Regular',
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AllNews(news: "Breaking")));
                            },
                            child: const Text(
                              "View All",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: CarouselSlider.builder(
                        itemCount: 5,
                        itemBuilder: (context, index, realIndex) {
                          String? res = sliders[index].urlToImage;
                          String? res1 = sliders[index].title ??
                              ""; // Handling potential null value
                          String? res2 = sliders[index].url;
                          return buildImage(res!, index, res1, res2!);
                        },
                        options: CarouselOptions(
                            height: 250,
                            autoPlay: true,
                            enlargeStrategy: CenterPageEnlargeStrategy.height,
                            onPageChanged: ((index, reason) {
                              setState(() {
                                activeIndex = index;
                              });
                            })),
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Center(child: buildIndicator(activeIndex, sliders.length)),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Trending News",
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AllNews(news: "Trending")));
                            },
                            child: const Text(
                              "View All",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Container(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: articles.length,
                        itemBuilder: (context, index) {
                          return BlogTile(
                            url: articles[index].url!,
                            desc: articles[index].description!,
                            image: articles[index].urlToImage!,
                            title: articles[index].title!,
                            isDarkMode: isDarkMode, // Pass isDarkMode here
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Material(
                        elevation: 3.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    'images/sport.jpg',
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5.0),
                              Column(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 1.8,
                                    child: Text(
                                      'Here is the title of the trending news coming from an API',
                                      style: TextStyle(
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 3.0,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 1.8,
                                    child: Text(
                                      'Here is the description of the trending news, will also come from an API',
                                      style: TextStyle(
                                        color: isDarkMode
                                            ? Colors.white70
                                            : Colors.black54,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'Settings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                title: const Text(
                  'Dark Mode',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                trailing: Switch(
                  value: isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      isDarkMode = value;
                    });
                  },
                  activeColor: Colors.blue,
                ),
              ),
            ],
          ),
        ),
         bottomNavigationBar: AnimatedContainer(
                 duration: const Duration(milliseconds: 400),
                 curve: Curves.easeInOut,
                 decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
              _currentIndex = index; // Update the current index
            });
            // Perform actions based on the tapped tab index
            if (index == 0) {
              // Navigate to Home page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Home()), // Replace `Home()` with the actual Home page widget
              );
            } else if (index == 1) {
              // Navigate to Categories page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoriesPage(
                    categories: categories,
                    isDarkMode: isDarkMode, // Pass the isDarkMode flag
                  ),
                ), // Replace `CategoriesPage()` with the actual Categories page widget
              );
            }
            // Add more conditions for other tabs if needed
          },
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: 'Categories',
            ),
            // Add more bottom navigation items as needed
          ],
          backgroundColor: Colors.transparent, // Transparent background
          selectedItemColor: Colors.blue, // Selected tab color
          unselectedItemColor: Colors.grey, // Unselected tab color
          showSelectedLabels: true, // Show labels for selected tab
          showUnselectedLabels: true, // Show labels for unselected tabs
                 ),
               ),
    ),
    );
  }

  Widget buildImage(String image, int index, String name, String blogUrl) =>
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ArticleView(blogUrl: blogUrl)));
          },
          child: Container(
            child: Stack(children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    height: 250,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                    imageUrl: image,
                  )),
              Container(
                height: 250.0,
                padding: const EdgeInsets.only(left: 10.0),
                margin: const EdgeInsets.only(top: 170.0),
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                ),
                child: Text(
                  name,
                  maxLines: 2,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ]),
          ),
        ),
      );
}

Widget buildIndicator(int activeIndex, int length) {
  return AnimatedSmoothIndicator(
    activeIndex: activeIndex,
    count: 5,
    effect: const ExpandingDotsEffect(activeDotColor: Colors.blue),
  );
}

class CategoryTile extends StatelessWidget {
  final String categoryName;
  CategoryTile({required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryNews(name: categoryName)));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        padding: const EdgeInsets.all(10.0),
        width: 180,
        height: 80,
        decoration: BoxDecoration(
          color: const Color.fromARGB(137, 237, 236, 236),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            const BoxShadow(
              color: Colors.black12,
              blurRadius: 5.0,
              spreadRadius: 2.0,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            categoryName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

class BlogTile extends StatelessWidget {
  final String image, title, desc, url;
  static int counter = 0;
  final bool isDarkMode; // Added isDarkMode variable

  BlogTile(
      {required this.image,
      required this.title,
      required this.desc,
      required this.url,
      required this.isDarkMode}) {
    counter++;
  }

  @override
  Widget build(BuildContext context) {
    bool isOdd = counter.isOdd;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleView(blogUrl: url),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Material(
            elevation: 3.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display image on the left for odd-indexed news items and on the right for even-indexed news items
                  if (isOdd)
                    Container(
                      width: 120,
                      height: 120,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: image,
                          fit: BoxFit.cover,
                          width: 120,
                          height: 120,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                  const SizedBox(width: 10), // Add spacing between images and text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: isDarkMode
                                ? Colors.white
                                : Colors
                                    .black, // Access isDarkMode from the constructor
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          desc,
                          style: TextStyle(
                            color: isDarkMode
                                ? Colors.white70
                                : Colors
                                    .black54, // Access isDarkMode from the constructor
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10), // Add spacing between images and text
                  // Display image on the right for odd-indexed news items and on the left for even-indexed news items
                  if (!isOdd)
                    Container(
                      width: 120,
                      height: 120,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: image,
                          fit: BoxFit.cover,
                          width: 120,
                          height: 120,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
