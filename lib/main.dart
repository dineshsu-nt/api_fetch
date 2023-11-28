import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'screens/now_playing_screen.dart';
import 'screens/top_rated_movie_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const HomeScreen(),
        );
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _AdminBNBScreenState();
}

class _AdminBNBScreenState extends State<HomeScreen> {
  int selectedScreenIndex = 0;

  final List<Widget> screens = [
    MovieListScreen(),
    TopRatedMovies(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedScreenIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.orangeAccent,
        elevation: 20,
        currentIndex: selectedScreenIndex,
        onTap: (value) {
          setState(() {
            selectedScreenIndex = value;
          });
        },
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle),
            label: 'Now Playing',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Top Rated',
          ),
        ],
      ),
    );
  }
}
