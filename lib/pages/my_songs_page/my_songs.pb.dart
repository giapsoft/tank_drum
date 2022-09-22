part of 'my_songs.page.dart';

@Page_(state: [
  SF_<int>(name: 'tabIdx'),
])
class MySongsBuilder extends MySongs$Builder {
  @override
  Widget build() {
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 5,
        child: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.verified_user_sharp), label: 'Mine'),
            BottomNavigationBarItem(icon: Icon(Icons.shop), label: 'Buyed'),
          ],
          currentIndex: state.tabIdx,
          selectedItemColor: Colors.amber[800],
          onTap: (idx) => state.tabIdx = idx,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(onPressed: () {}),
      drawer: const SideBar(),
    );
  }
}
