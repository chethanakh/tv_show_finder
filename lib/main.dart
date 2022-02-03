import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tv_info/Helpers/find_tv.dart';
import 'package:tv_info/Modals/tv_show.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TV Info',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 5000), () {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const HomeScreen()),
      // );
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;

    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: Image(image: AssetImage("images/tv.png")),
              width: deviceSize.width / 2,
            ),
            SizedBox(
              height: deviceSize.height / 18,
            ),
            const SpinKitCircle(
              color: Colors.blue,
              size: 80.0,
            )
          ],
        ),
      ),
    ));
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TvShow> tvShowList = [];
  bool isLoading = false;
  bool isNoReult = false;
  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("TV Info"),
        actions: [
          IconButton(
            onPressed: () => {},
            icon: Icon(Icons.more_vert_outlined),
          )
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              CircleAvatar(
                radius: 60,
                child: Text(
                  "CK",
                  style: TextStyle(fontSize: 55),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text("Chethana Kalpa", style: TextStyle(fontSize: 30)),
              SizedBox(
                height: 5,
              ),
              Text("Reguler user", style: TextStyle(color: Colors.black38))
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: TextField(
                  onChanged: (value) => {fetchSearchResult(value)},
                  // onSubmitted: (value) => {fetchSearchResult(value)},
                  decoration: InputDecoration(
                    hintText: "Type TV Show name ...",
                    suffix: IconButton(
                      onPressed: null,
                      icon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Visibility(
              visible: isLoading,
              child: const SpinKitCircle(
                color: Colors.blue,
                size: 60,
              ),
            ),
            Visibility(
                visible: isNoReult, child: const Text("No Reult Founed")),
            Visibility(
              visible: !isLoading,
              child: Flexible(
                flex: 3,
                child: ListView.builder(
                  itemCount: tvShowList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: FadeInImage.assetNetwork(
                        placeholder: 'images/tv.png',
                        image: tvShowList[index].imageUrl,
                        imageErrorBuilder: (context, url, error) =>
                            new Icon(Icons.error),
                      ),
                      title: Text(tvShowList[index].name),
                      subtitle: Text("Air Date : " + tvShowList[index].type),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void fetchSearchResult(query) {
    setNoResult(false);
    setLoadingStatus(true);
    FindTv().showSearch(query).then((value) => {setApiResulttoTheList(value)});
  }

  void setApiResulttoTheList(data) {
    tvShowList = data;
    if (data.length <= 0) {
      setNoResult(true);
    }
    setLoadingStatus(false);
  }

  void setLoadingStatus(status) {
    setState(() {
      isLoading = status;
    });
  }

  void setNoResult(status) {
    setState(() {
      isNoReult = status;
    });
  }
}
