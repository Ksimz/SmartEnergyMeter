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

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String zan;
  String result;
  String result2;

  final TextEditingController controller1 = TextEditingController();
  final TextEditingController controller2 = TextEditingController();

  Future<http.Response> getData() async {
    print("101 executing");
    var response = await http.post(
        Uri.encodeFull("http://10.1.39.252/Login.php"),
        headers: {"Accept": "application/json"},
        body: {"customerNumber": result, "password": result2});
    print(response.body);

    Map<String, dynamic> data = json.decode(response.body);
    //print(data["success"]);
    zan = data["success"];
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
              Text("T.I.A Powering The World")
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
                  child: TextField(
                    onSubmitted: (String str) {
                      setState(() {
                        result = str;
                        print(result);
                      });
                      // controller1.text = " ";
                    },
                    controller: controller1,
                  ),
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
                  child: TextField(
                    onSubmitted: (String ptr) {
                      setState(() {
                        result2 = ptr;
                        print(ptr);
                        // controller1.text = " ";
                        //  controller2.text = " ";
                      });
                    },
                    controller: controller2,
                  ),
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
                    if (zan == "Welcome") {
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
  final TextEditingController controller3 = TextEditingController();

  var balance = "";
  var paid;

  Future<http.Response> getBalance() async {
    var response1 = await http.post(
        Uri.encodeFull("http://10.1.39.252/Balance.php"),
        headers: {"Accept": "application/json"},
        body: {"CustomerNumber": '1000'});
    print(response1.body);
    Map<String, dynamic> data = json.decode(response1.body);
    controller3.text = " " + "R" + data["balance"];
  }

  void recharge() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    getBalance();
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
              Expanded(
                  child: TextField(
                controller: controller3,
                enabled: false,
              )),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Text("Amount :R"),
              Expanded(child: TextField(
                onSubmitted: (String tre) {
                  setState(() {
                    paid = tre;
                    print("Paid:" + paid);
                  });
                },
              )),
            ],
          ),
        ),
        Container(
          child: RaisedButton(
              child: Text("Pay"),
              onPressed: () {
                Pay();
                getBalance();
              }),
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

  Future<http.Response> Pay() async {
    var response2 = await http.post(
        Uri.encodeFull("http://10.1.39.252/Payment.php"),
        headers: {"Accept": "application/json"},
        body: {"CustomerNumber": '1000', "Amount": paid});
    print(response2.body);
    //Map<String, dynamic> data = json.decode(response2.body);
    // controller3.text=" "+"R"+data["balance"];
  }
}
