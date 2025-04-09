import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kelimbo_admin/utils/color.dart';
import 'package:kelimbo_admin/web_screen/user_web_detail/user_web_detail.dart';

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "No hay usuarios registrados",
                style: TextStyle(color: colorBlack),
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final List<DocumentSnapshot> documents = snapshot.data!.docs;
              final Map<String, dynamic> data =
                  documents[index].data() as Map<String, dynamic>;

              return Card(
                  child: GestureDetector(
                onTap: () {},
                child: ListTile(
                  leading: GestureDetector(
                    child: CircleAvatar(
                      backgroundImage:
                          NetworkImage(data['image'] ?? "assets/logo.png"),
                    ),
                  ),
                  title: Text(
                    data['fullName'] ?? "No Title",
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Text(
                    data['email'] ?? "No Subtitle",
                    style: GoogleFonts.inter(
                        color: Color(0xff9C9EA2),
                        fontWeight: FontWeight.w300,
                        fontSize: 15),
                  ),
                  trailing: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => UserWebDetail(
                                      uid: data['uid'] ?? "No Title",
                                      fullName: data['fullName'],
                                      image: data['image'] ?? "assets/logo.png",
                                      email: data['email'],
                                      phoneNumber: data['phone'],
                                      numberofjobs:
                                          data['numberofjobs'].toString(),
                                    )));
                      },
                      child: Text("View")),
                  // trailing: GestureDetector(
                  //   onTap: () async {
                  //     final docRef = FirebaseFirestore.instance
                  //         .collection("services")
                  //         .doc(data['uuid']);
                  //     await docRef.update({
                  //       "favorite": FieldValue.arrayRemove([currentUserId])
                  //     });
                  //   },
                  //   child: Icon(
                  //     Icons.view_agenda,
                  //     color: red,
                  //   ),
                  // ),
                ),
              ));
            },
          );
        },
      ),
    );
  }
}

String getCurrencySymbol(String currency) {
  switch (currency) {
    case 'Euro':
      return '€';
    case 'USD':
      return '\$';
    case 'BTC':
      return '₿';
    case 'ETH':
      return 'Ξ';
    case 'G1': // Add custom icons or symbols as needed
      return 'G1';
    default:
      return ''; // Default to no symbol if currency is unrecognized
  }
}
