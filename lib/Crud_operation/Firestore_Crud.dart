import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCrud extends StatefulWidget {
  const FirebaseCrud({Key? key}) : super(key: key);

  @override
  State<FirebaseCrud> createState() => _FirebaseCrudState();
}

class _FirebaseCrudState extends State<FirebaseCrud> {
  TextEditingController _controller = TextEditingController();
  final db = FirebaseFirestore.instance.collection('Collection');
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange.shade100,
        title: Center(
          child: Text('To Do List App'),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextFormField(
                controller: _controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  loading = true; // Start showing loading indicator
                });
                await db.add({'name': _controller.text});
                _controller.clear();
                setState(() {
                  loading = false; // Stop showing loading indicator
                });
              },
              child: Text('Add Data'),
            ),
            if (loading) CircularProgressIndicator(), // Show loading indicator when loading is true
            StreamBuilder(
              stream: db.snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot documentSnapshot =
                            snapshot.data.docs[index];
                        return Padding(
                          padding: const EdgeInsets.all(15),
                          child: Card(
                            color: Colors.deepOrange.shade100,
                            child: ListTile(
                              title: Text(documentSnapshot['name']),
                              leading: IconButton(
                                onPressed: () async {
                                  String newName = documentSnapshot['name'] ?? '';
                                  newName = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Edit Name'),
                                        content: TextFormField(
                                          initialValue:
                                              documentSnapshot['name'],
                                          onChanged: (value) {
                                            newName = value;
                                          },
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context, null);
                                            },
                                            child: Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context, newName);
                                            },
                                            child: Text('Save'),
                                          ),
                                        ],
                                      );
                                    },
                                  ) ?? newName;
                                  db
                                      .doc(documentSnapshot.id)
                                      .update({'name': newName});
                                },
                                icon: Icon(
                                  Icons.check_circle,
                                  color: Colors.blue,
                                ),
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  db.doc(documentSnapshot.id).delete();
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
