import 'package:ex_t1_app/src/pages/seller/seller_home_controller.dart';
import 'package:ex_t1_app/src/providers/auth_provider.dart';
import 'package:ex_t1_app/src/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:video_player/video_player.dart';

class SellerHomePage extends StatefulWidget {
  const SellerHomePage({Key? key}) : super(key: key);

  @override
  _SellerHomePageState createState() => _SellerHomePageState();
}

class _SellerHomePageState extends State<SellerHomePage> {
  SellerHomeController _con = SellerHomeController();
  late AuthProvider _authProvider;
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/video/video.mp4');
    _controller.addListener(() {
      setState(() {});
    });
    _controller.initialize().then((value) {
      setState(() {});
    });
    _controller.play();
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
    _authProvider = new AuthProvider();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.key,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Column(
          children: [
            SizedBox(height: 40),
            _menuDrawer(),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              await _authProvider.signOut();
              Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
            },
            child: Container(
              margin: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.logout,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      drawer: _drawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    VideoPlayer(_controller),
                    VideoProgressIndicator(
                      _controller,
                      allowScrubbing: true,
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _controller.value.isPlaying ? _controller.pause() : _controller.play();
              },
              child: Icon(Icons.pause),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuDrawer() => GestureDetector(
        onTap: _con.openDrawer,
        child: Container(
          margin: EdgeInsets.only(left: 20.0),
          alignment: Alignment.centerLeft,
          child: Image.asset(
            'assets/img/menu.png',
            width: 20.0,
            height: 20.0,
          ),
        ),
      );
  Widget _drawer() => Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: MyColors.primaryColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${_con.user?.name ?? ''} ${_con.user?.lastname ?? ''}',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    _con.user?.email ?? '',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            ListTile(
              onTap: _con.goToUpdatePage,
              title: Text('Inicio'),
              trailing: Icon(Icons.home),
            ),
            ListTile(
              onTap: _con.goToCreate,
              title: Text('Agregar un servicio'),
              trailing: Icon(Icons.add),
            ),
            ListTile(
              title: Text('Editar servicio'),
              trailing: Icon(Icons.edit_outlined),
              onTap: _con.goToSearch,
            ),
            ListTile(
              title: Text('Bajas de servicio'),
              trailing: Icon(Icons.delete),
              onTap: _con.goToList,
            ),
            ListTile(
              title: Text('Ventas'),
              trailing: Icon(Icons.shopping_bag),
              onTap: _con.goToOrders,
            ),
            ListTile(
              title: Text('Creditos'),
              trailing: Icon(Icons.info),
              onTap: _con.goToCredits,
            ),
          ],
        ),
      );
  refresh() {
    setState(() {});
  }
}
