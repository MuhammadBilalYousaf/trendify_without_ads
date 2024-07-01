import 'package:flutter/material.dart';
import 'package:trendify/models/category_model.dart';
import 'package:trendify/pages/category_page.dart';
import 'package:trendify/pages/home.dart';
import 'package:trendify/services/data.dart';
import 'package:trendify/services/news.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPage();
}

class _ContactPage extends State<ContactPage> {

List<CategoryModel> categories = [];
int _currentIndex = 2;
bool _loading = true;


@override
  void initState() {
    categories = getCategories();
    fetchData();
    super.initState();
  }

fetchData() async {
    await getNews();
    setState(() {
      _loading = false;
    });
  }

  getNews() async {
    News newsclass = News();
    await newsclass.getNews();

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Contact Us',style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ContactInfo(
              icon: Icons.email,
              text: 'bilalyousaf629422@gmail.com',
              onTap: () {
                _launchEmail('bilalyousaf629422@gmail.com');
              },
            ),
            SizedBox(height: 20),
            ContactInfo(
              icon: Icons.phone,
              text: '+923115318776',
              onTap: () {
                _launchWhatsApp('+923115318776');
              },
            ),
            SizedBox(height: 20),
            ContactInfo(
              icon: Icons.man,
              text: 'Bilal Yousaf',
              onTap: () {
                _launchURL('https://www.instagram.com/bilalyousafuniboy/');
              },
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
              if (index == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(),
                  ),
                );
              }
              else if (index == 1) {
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
    );
  }

  Future<void> _launchEmail(String emailAddress) async {
    final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: emailAddress,
    );
    if (await canLaunch(_emailLaunchUri.toString())) {
      await launch(_emailLaunchUri.toString());
    } else {
      throw 'Could not launch $emailAddress';
    }
  }

  Future<void> _launchWhatsApp(String phoneNumber) async {
    final Uri _whatsappLaunchUri = Uri(
      scheme: 'https',
      host: 'wa.me',
      path: '/$phoneNumber',
    );
    if (await canLaunch(_whatsappLaunchUri.toString())) {
      await launch(_whatsappLaunchUri.toString());
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class ContactInfo extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const ContactInfo({
    required this.icon,
    required this.text,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Wrap(
          children: [
            Icon(icon, size: 30, color: Colors.blue),
            SizedBox(width: 20),
            Text(
              text,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}