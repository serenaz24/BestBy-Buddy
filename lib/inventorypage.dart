import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Inventory_Page extends StatefulWidget {
  Inventory_Page({Key? key}) : super(key: key);

  @override
  _Inventory_PageState createState() => _Inventory_PageState();
}

class _Inventory_PageState extends State<Inventory_Page> {
  final user = FirebaseAuth.instance.currentUser!;

// text fields' controllers
  final TextEditingController _foodNameController = TextEditingController();
  final TextEditingController _expDateController = TextEditingController();

  @override
  void dispose() {
    _foodNameController.dispose();
    _expDateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }




  List<String> food_items = [];

  void sort_items(List food_items, added_food) {
    if (food_items.isEmpty) {
      food_items.add(added_food);
    }
    else {
      var split_item1 = added_food.split(",");
      var expiration1 = split_item1[1].split("/");
      for (var i = 0; i < food_items.length; i++) {
        var split_item = food_items[i].split(",");
        var expiration = split_item[1].split("/");
        if (int.parse(expiration[2]) > int.parse(expiration1[2])) {
          food_items.insert(i, added_food);
          break;
        }
        else if (int.parse(expiration[1]) > int.parse(expiration1[1])) {
          food_items.insert(i, added_food);
          break;
        }
        else if (int.parse(expiration[0]) > int.parse(expiration1[0])) {
          food_items.insert(i, added_food);
          break;
        }
        else {
          food_items.add(added_food);
        }
      }
    }
  }

  //food_items.add('${data['food name']},' + ' ' + '${data['expiration date']}');



  @override
  Widget build(BuildContext context) {
    final CollectionReference _inventory = FirebaseFirestore.instance.collection(user.email!);

    Future<void> _create([DocumentSnapshot? documentSnapshot]) async {

      await showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            return Padding(
              padding: EdgeInsets.only(
                  top: 20, left: 20, right: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
              child: Column(
                mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _foodNameController,
                    decoration: const InputDecoration(
                        labelText: 'Food Name',
                        labelStyle: TextStyle(fontSize: 20, color: Color(0xFF4E841A)))),
                  TextField(
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    controller: _expDateController,
                    decoration: const InputDecoration(
                        labelText: 'Expiration Date',
                        labelStyle: TextStyle(fontSize: 20, color: Color(0xFF4E841A)),
                        hintText: 'MM/DD/YY')),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(170, 60),
                          backgroundColor: Color(0xFF76A737),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          padding: EdgeInsets.all(12)),
                      child: Center(
                          child: const Text('Create',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22))),
                      onPressed: () async {
                        final String foodName = _foodNameController.text;
                        final String expDate = _expDateController.text;
                        final today = DateTime(2023, 9, 20);
                        final expList = expDate.split("/");
                        var exp = DateTime(int.parse("20" + expList[2]), int.parse(expList[0]), int.parse(expList[1]));
                        final difference = today.difference(exp);
                        if (expDate != null) {
                          await _inventory.add({"food name": foodName, "expiration date": expDate, "order": int.parse(difference.inDays.toString())});
                          _foodNameController.text = '';
                          _expDateController.text = '';
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  )
                ],
              ),
            );

          });
    }

    Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
      if (documentSnapshot != null) {
        _foodNameController.text = documentSnapshot['food name'];
        _expDateController.text = documentSnapshot['expiration date'].toString();
      }

      await showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            return Padding(
              padding: EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _foodNameController,
                    decoration: const InputDecoration(
                        labelText: 'Food Name',
                        labelStyle: TextStyle(fontSize: 20, color: Color(0xFF4E841A))),
                  ),
                  TextField(
                    keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                    controller: _expDateController,
                    decoration: const InputDecoration(
                        hintText: 'MM/DD/YY',
                        labelText: 'Expiration Date',
                        labelStyle: TextStyle(fontSize: 20, color: Color(0xFF4E841A))
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(170, 60),
                          backgroundColor: Color(0xFF76A737),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          padding: EdgeInsets.all(12)),
                      child: Center(
                          child: const Text('Update',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22))),
                      onPressed: () async {
                        final String foodName = _foodNameController.text;
                        final String expDate = _expDateController.text;
                        final today = DateTime(2023, 9, 20);
                        final expList = expDate.split("/");
                        var exp = DateTime(int.parse("20" + expList[2]), int.parse(expList[0]), int.parse(expList[1]));
                        final difference = today.difference(exp);
                        if (expDate != null) {
                          await _inventory
                              .doc(documentSnapshot!.id)
                              .update({"food name": foodName, "expiration date": expDate, "order": int.parse(difference.inDays.toString())});
                          _foodNameController.clear();
                          _expDateController.clear();
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  )
                ],
              ),
            );
          });
    }

    Future<void> _delete(String productId) async {
      await _inventory.doc(productId).delete();

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              backgroundColor: Color(0xFF619427),
              behavior: SnackBarBehavior.floating,
              elevation: 15,
              duration: Duration(milliseconds: 1000),
              shape: StadiumBorder(),
              content: Text('Successfully deleted food item',
                  style: TextStyle(color: Colors.white,
                      fontSize: 18,
                      fontFamily: "Mona Sans"))));
    }

    return Scaffold(
        appBar: AppBar(
            title: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text(
                  "Inventory",
                  style: TextStyle(
                      color: Color(0xFF76A737),
                      fontWeight: FontWeight.w300,
                      fontSize: 27.0),
                )),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0.0),
        body: StreamBuilder(
          stream: _inventory.orderBy("order", descending: true).snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[index];
                  if((documentSnapshot.data() as Map).containsKey("food name"))
                  {
                    return Card(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Color(0xFF91BA5A), width: 2.0),
                          borderRadius: BorderRadius.circular(100.0)),
                      color: Color(0xFFFAF8EE),
                      margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(documentSnapshot['food name'],
                                    style: TextStyle(
                                        fontSize: 21,
                                        color: Color(0xFF4E841A)
                                    )),
                                SizedBox(height: 4.0), // Adjust the desired spacing here
                              ],
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(documentSnapshot['expiration date'],
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.black87)),
                          ),
                          trailing: SizedBox(
                            width: 100,
                            child: Row(
                              children: [
                                IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Color(0xFF6B9D2F)),
                                    onPressed: () =>
                                        _update(documentSnapshot)),
                                IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Color(0xFF6B9D2F)),
                                    onPressed: () =>
                                        _delete(documentSnapshot.id)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  else {
                    return SizedBox();
                  };
                },
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
        floatingActionButton: Positioned(
          bottom: 3,
          right: 0,
          child: FloatingActionButton(
              heroTag: null,
              onPressed: () {
                _foodNameController.clear();
                _expDateController.clear();
                _create();
                },
              child: Icon(
                  Icons.add, color: Colors.white),
              backgroundColor: Color(0xFF619427)
          ),
        ),
    );
  }
}