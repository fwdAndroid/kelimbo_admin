import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kelimbo_admin/screens/add_categories/add_categories.dart';
import 'package:kelimbo_admin/utils/color.dart';

class Newcategoy extends StatefulWidget {
  const Newcategoy({super.key});

  @override
  State<Newcategoy> createState() => _NewcategoyState();
}

class _NewcategoyState extends State<Newcategoy> {
  Future<void> _deleteItem(BuildContext context, String type, String name,
      DocumentSnapshot categoryDoc) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text(
            type == 'header'
                ? 'Are you sure you want to delete the category "$name"? This will delete all its subcategories.'
                : 'Are you sure you want to delete the subcategory "$name"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        if (type == 'header') {
          // Delete the entire category document
          await categoryDoc.reference.delete();
        } else {
          // Delete the specific subcategory
          List<dynamic> subcategories = categoryDoc['subcategories'] ?? [];
          subcategories.remove(name);
          await categoryDoc.reference.update({'subcategories': subcategories});
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$type "$name" deleted successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('categories').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text("Error loading categories"),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No categories found"),
            );
          }

          // Extract data from snapshot
          final categories = snapshot.data!.docs;

          // Create a combined list of categories and subcategories
          List<Map<String, dynamic>> combinedList = [];

          for (var category in categories) {
            String categoryName = category['category'];
            List<dynamic> subcategories = category['subcategories'] ?? [];

            // Add category as a header
            combinedList
                .add({'type': 'header', 'name': categoryName, 'doc': category});

            // Add each subcategory as an item
            for (var sub in subcategories) {
              combinedList.add({
                'type': 'subcategory',
                'name': sub.toString(),
                'doc': category
              });
            }
          }

          return ListView.builder(
            itemCount: combinedList.length,
            itemBuilder: (context, index) {
              var item = combinedList[index];

              if (item['type'] == 'header') {
                // Render category header
                return Container(
                  color: Colors.grey[300],
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    item['name'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              } else {
                // Render subcategory
                return ListTile(
                  trailing: IconButton(
                    onPressed: () => _deleteItem(
                      context,
                      item['type'],
                      item['name'],
                      item['doc'],
                    ),
                    icon: Icon(
                      Icons.delete,
                      color: red,
                    ),
                  ),
                  title: Text(item['name']),
                );
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (builder) => const AddCategories()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
