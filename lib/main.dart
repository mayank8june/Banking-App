import 'package:bank_app/Users.dart';
import 'package:bank_app/customerview.dart';
import 'package:bank_app/database.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Users> newusers;

  @override
  void initState() {
    // TODO: implement initState
    refreshList();
    super.initState();
  }

  refreshList() async{
    newusers = await DBProvider.db.getAllUsers();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [SizedBox(height:MediaQuery.of(context).padding.top+5,),
            Text("Bank Accounts",
              style: TextStyle(fontSize: 35,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'TCM'),),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: FutureBuilder(
                    future: DBProvider.db.getAllUsers(),
                  builder: (context,AsyncSnapshot<List<Users>> snapshot) {
                    if (snapshot.hasData) {
                      print('project snapshot data is: ${snapshot.data}');
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            var project = snapshot.data[index];
                            return buildCard(context, project);
                          }
                      );
                    }return CircularProgressIndicator();

                  }),),
            ),
          ],
        ),
      )
    );
  }
}
Widget buildCard(context,var snapshot){
  final user = snapshot;
  return Container(
    child:Card(
      color: Colors.blue[100],
      elevation: 0,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: (){showDialogBox(context, user.username, user.balance);},
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Padding(
              padding: EdgeInsets.symmetric(horizontal: 3),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(user.username,
                    style: TextStyle(
                      fontFamily: 'heav',
                      fontSize: 20,
                    ),), Text(user.email,
                    style: TextStyle(
                        fontFamily: 'mic',
                        fontSize: 15
                    ),)]),
            ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Text("₹ "+user.balance.toString(),
                  style: TextStyle(
                      color: Colors.black45,
                      fontFamily: 'luc',
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              )],
          ),
        ),
      ),
    ),
  );
}



showDialogBox(context, username, balance){

  return showDialog(context: context,
      builder: (context){
        return Center(
          child:Material(
            type: MaterialType.transparency,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(20),
              height: 320,
              width: MediaQuery.of(context).size.width*0.7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Row(
                  children: [FlutterLogo(size: 50,),
                    SizedBox(
                      width: 5,
                    ),
                    Text("GoBank",
                      style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'heav'),)
                  ],
                ),
                  Text("Name: $username",
                    style: TextStyle(
                      fontFamily: 'TCM',
                      fontSize: 25,),),
                  Text("Current Balance: ₹$balance",
                    style: TextStyle(
                        fontFamily: 'TCM',
                        fontSize: 25),),
                  SizedBox(height: 10,),
                  TextButton(onPressed: () {
                    Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => CustomerView(),
                          settings: RouteSettings(arguments: [username, balance])),);
                  },
                      child: Text("Transfer"))],
              ),
            ),
          ),
        );
      });
}
