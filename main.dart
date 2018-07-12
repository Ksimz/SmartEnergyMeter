import "dart:async";
import "package:flutter/material.dart";
import "package:path/path.dart";
import 'package:http/http.dart' as http;
import "dart:convert";

void main() {
  runApp(MaterialApp(
    title: ' TIA POWER UTILITY',
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  String zan;

  Future<http.Response> getData() async {
    print("101 executing");
    var response = await http.post(
        Uri.encodeFull("http://10.1.39.252/Login.php"),
        headers: {"Accept": "application/json"},
        body: {"customerNumber": "1000", "password": "saveg"});
    print(response.body);

    Map<String, dynamic> data = json.decode(response.body);
    //print(data["success"]);
    zan=data["success"];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TIA POWER UTILITY"),
      ),
      body: ListView(children: <Widget>[
        Card(
          child: Column(
            children: <Widget>[
              Image.asset("assets/23thelectricity.jpeg"),
              Text("Powering The World")
            ],
          ),
        ),
        Column(children: <Widget>[
          Container(
            margin: const EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(10.0),
                  child: Text('User Name'),
                ),
                Expanded(
                  child: TextField(),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(10.0),
                  child: Text('Password'),
                ),
                Expanded(
                  child: TextField(),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(20.0),
            child: Center(
              child: RaisedButton(
                  child: Text("Login"),
                  onPressed: () {

                      getData();
                      print(zan);
                      if(zan=="Welcome") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NextPage()),
                        );
                      }
                  }),
            ),
          )
        ]),
      ]),
    );
  }
}
// creating the second page a stateful widget

class NextPage extends StatefulWidget {
  @override
  _NextPageState createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {

  var balance = "";
  var paid;

  void recharge() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" METER VALUES"),
      ),
      body: Column(children: <Widget>[
        Container(
          margin: const EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Text("Balance"),
              Expanded(child: TextField()),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Text("Amount"),
              Expanded(child: TextField()),
            ],
          ),
        ),
        Container(
          child: RaisedButton(child: Text("Pay"), onPressed: (){}),
        ),
        Container(
          margin: const EdgeInsets.all(40.0),
          child: RaisedButton(
              child: Text("Logout"),
              onPressed: () {
                Navigator.pop(context);
              }),
        )
      ]),
    );
  }
}
