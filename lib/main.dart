import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_firebase/models/calling.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: CrudFirebase(),
    debugShowCheckedModeBanner: false,
  ));
}

class CrudFirebase extends StatefulWidget {
  const CrudFirebase({Key? key}) : super(key: key);

  @override
  State<CrudFirebase> createState() => _CrudFirebaseState();
}

class _CrudFirebaseState extends State<CrudFirebase> {
  // String? name;
  // String? email;
  // String crt = "reg";

  final name = TextEditingController();
  final email = TextEditingController();

  final firebase = FirebaseFirestore.instance;

  create(String name, String ema) async {
    await Firebase.initializeApp();
    WidgetsFlutterBinding.ensureInitialized();

    try {
      await firebase.collection("user").add({
        'name': name,
        'email': ema,
      });
    } catch (e) {
      print(e);
    }
  }

  update() async {
    try {
      firebase.collection("user").doc().update({
        'name': name.text,
        'email': email.text,
      });
    } catch (e) {
      print(e);
    }
  }

  delete() async {
    try {
      firebase.collection("user").doc().delete();
    } catch (e) {
      print(e);
    }
  }

  Future<List<Voking>> getdata() async {
    final j = firebase.collection("user");
    final data = await j.get();
    // print(data.docs[0].get('name'));
    return data.docs.map((e) => Voking.fromJson(e.data())).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crud Firebase', style: TextStyle(fontSize: 20)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          TextField(
              controller: name,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                labelText: 'User.....',
                labelStyle: TextStyle(fontSize: 19),
                suffixIcon: Icon(
                  Icons.person,
                  size: 20,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              )),
          SizedBox(
            height: 20,
          ),
          TextField(
              controller: email,
              // onChanged: (val) {
              //   email = val;
              // },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                labelText: 'email...',
                labelStyle: TextStyle(fontSize: 19),
                suffixIcon: Icon(
                  Icons.email,
                  size: 20,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              )),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await create(name.text, email.text);
                  name.clear();
                  email.clear();
                },
                child: Text('Create', style: TextStyle(fontSize: 20)),
                style: TextButton.styleFrom(backgroundColor: Colors.green),
              ),
              ElevatedButton(
                onPressed: () {
                  update();
                  // name.clear();
                  // email.clear();
                },
                child: Text(
                  'Update',
                  style: TextStyle(fontSize: 20),
                ),
                style: TextButton.styleFrom(backgroundColor: Colors.amber),
              ),
              ElevatedButton(
                onPressed: () {
                  delete();
                },
                child: Text('Delete', style: TextStyle(fontSize: 20)),
                style: TextButton.styleFrom(backgroundColor: Colors.red),
              ),
            ],
          ),
          Divider(
            height: 20,
            color: Colors.black,
          ),
          FutureBuilder<List<Voking>>(
              future: getdata(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());
                final data = snapshot.data!;
                return Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: data.length,
                      itemBuilder: (ctx, index) {
                        return SelectItem(
                          pss: data[index],
                        );
                      }),
                );
              })
        ]),
      ),
    );
  }
}

class SelectItem extends StatelessWidget {
  const SelectItem({
    Key? key,
    required this.pss,
  }) : super(key: key);

  final Voking pss;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(topRight: Radius.circular(30))),
          width: double.infinity,
          height: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  left: 10,
                ),
                child: Row(
                  children: [
                    Text(
                      'name: ',
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      pss.name ?? '',
                      style: TextStyle(fontSize: 22, color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  left: 10,
                ),
                child: Row(
                  children: [
                    Text('Email: ',
                        style: TextStyle(fontSize: 25, color: Colors.white)),
                    SizedBox(
                      width: 10,
                    ),
                    Text(pss.email ?? '',
                        style: TextStyle(fontSize: 22, color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
