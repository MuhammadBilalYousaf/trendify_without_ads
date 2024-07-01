import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:trendify/pages/all_news.dart';
import 'package:trendify/pages/article_view.dart';
import 'package:trendify/pages/category_news.dart';
import 'package:trendify/pages/category_page.dart';
import 'package:trendify/pages/contact_page.dart';
import 'package:trendify/services/data.dart';
import 'package:trendify/services/News.dart';
import 'package:trendify/models/category_model.dart';
import 'package:trendify/models/article_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:trendify/models/slider_model.dart';
import 'package:trendify/services/slider_data.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';

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

  int activeIndex = 0;
  int _currentIndex = 0;

  final List<Widget> _screens = [
    Home(),
  ];

  // Lists for dropdown menus
  List<String> countryList = [
    'us',
    'gr',
    'in',
    'nl',
    'za',
    'au',
    'hk',
    'nz',
    'kr',
    'at',
    'hu',
    'ng',
    'se',
    'uk'
  ];
  List<String> categoryList = [
    'business',
    'entertainment',
    'general',
    'health',
    'science',
    'sports',
    'technology'
  ];
  String selectedCountry = 'us';
  String selectedCategory = 'business';

  @override
  void initState() {
    categories = getCategories();
    fetchData();
    super.initState();
  }

  fetchData() async {
    await getSlider();
    await getNews();
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
    await slider.getSlider(selectedCountry, selectedCategory);
    sliders = slider.sliders;

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'TREND',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
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
                      child: Column(
                        children: [
                          Container(
                              height: 70,
                              color: Colors.black38,
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: categories.length,
                                itemBuilder: (context, index) {
                                  return CategoryTile(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        DropdownButton<String>(
                          dropdownColor: Colors.black,
                          value: selectedCountry,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedCountry = newValue!;
                              fetchData(); 
                            });
                          },
                          items: countryList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value.toUpperCase(),
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }).toList(),
                        ),
                        DropdownButton<String>(
                          dropdownColor: Colors.black,
                          value: selectedCategory,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedCategory = newValue!;
                              fetchData(); 
                            });
                          },
                          items: categoryList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value.toLowerCase(),
                                style: TextStyle(color: Colors.white),
                              ),
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
                              color: Colors.white,
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
                              
                              color: Colors.white,
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
                            title:
                                articles[index].title!, 
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
                    ),
                  ],
                ),
              ),
        bottomNavigationBar: AnimatedContainer(
          duration: Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
              if (index == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoriesPage(
                      categories: categories,
                    ),
                  ),
                );
              }
              else if (index == 2) {
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
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
        padding: const EdgeInsets.all(10.0),
        width: 150,
        height: 80,
        child: Center(
          child: Text(
            categoryName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class BlogTile extends StatefulWidget {
  final String title;
  final String desc;
  final String image;
  final String url;

  BlogTile({
    required this.title,
    required this.desc,
    required this.image,
    required this.url,
  });

  @override
  _BlogTileState createState() => _BlogTileState();
}

class _BlogTileState extends State<BlogTile> {
  static int counter = 0;

  @override
  void initState() {
    super.initState();
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
            builder: (context) => ArticleView(blogUrl: widget.url),
          ),
        );
      },
      child: Container(
        color: Colors.black,
        margin: const EdgeInsets.only(bottom: 10.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Material(
            color: Colors.black,
            elevation: 3.0,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isOdd)
                    Container(
                      width: 120,
                      height: 120,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: widget.image,
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
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          widget.desc,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (!isOdd)
                    Container(
                      width: 120,
                      height: 120,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: widget.image,
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
