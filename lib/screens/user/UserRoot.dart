import 'package:flutter/material.dart';
import 'package:smart_garden_app/screens/user/RegisterFace.dart';
import 'package:smart_garden_app/screens/user/UserHome.dart';

class UserRoot extends StatefulWidget {
  const UserRoot({super.key});

  @override
  State<UserRoot> createState() => _UserRootState();
}

class _UserRootState extends State<UserRoot> {
  int _currentIndex = 0;

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const[
          UserHome(),
          RegisterFace()
        ],
      ),
      bottomNavigationBar: UserRoute(currentIndex: _currentIndex, onTap: _onTap),
    );
  }
}

class UserRoute extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const UserRoute({Key? key, required this.currentIndex, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      notchMargin: 8.0,
      shape: const CircularNotchedRectangle(),
      color: Colors.lightGreen,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            color: currentIndex == 0
                ? Colors.white
                : Colors.white.withOpacity(0.5),
            onPressed: () => onTap(0),
            icon: const Icon(
              Icons.home_outlined,
              size: 30,
            ),
            hoverColor: Colors.white.withOpacity(0.2),
            splashRadius: 20,
            splashColor: Colors.white.withOpacity(0.5),
          ),
          IconButton(
            color: currentIndex == 1
                ? Colors.white
                : Colors.white.withOpacity(0.5),
            onPressed: () => onTap(1),
            icon: const Icon(
              Icons.face,
              size: 30,
            ),
            hoverColor: Colors.white.withOpacity(0.2),
            splashRadius: 20,
            splashColor: Colors.white.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}
