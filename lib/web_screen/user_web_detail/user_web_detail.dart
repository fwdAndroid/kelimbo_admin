import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kelimbo_admin/screens/pages/users_page.dart';
import 'package:kelimbo_admin/utils/color.dart';
import 'package:kelimbo_admin/web_screen/web_home/web_home.dart';

class UserWebDetail extends StatefulWidget {
  final String fullName;
  final String uid;
  final String image;
  final String email;
  final String phoneNumber;
  final String numberofjobs;
  const UserWebDetail(
      {super.key,
      required this.fullName,
      required this.email,
      required this.image,
      required this.numberofjobs,
      required this.phoneNumber,
      required this.uid});

  @override
  State<UserWebDetail> createState() => _UserWebDetailState();
}

class _UserWebDetailState extends State<UserWebDetail> {
  bool isLoading = false;
  //Program
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: CircleAvatar(
                radius: 70,
                backgroundImage: NetworkImage(widget.image),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.fullName,
                style: GoogleFonts.inter(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.email,
                style: GoogleFonts.inter(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.phoneNumber,
                style: GoogleFonts.inter(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      "Número de trabajos completados: ${widget.numberofjobs}"),
                ],
              ),
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("services")
                    .where("uid", isEqualTo: widget.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: Text(""),
                    );
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        "No hay servicio disponible",
                        style: TextStyle(color: colorBlack),
                      ),
                    );
                  }
                  return SizedBox(
                    height: 400,
                    child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final List<DocumentSnapshot> documents =
                              snapshot.data!.docs;
                          final Map<String, dynamic> data =
                              documents[index].data() as Map<String, dynamic>;

                          return Card(
                            child: Column(
                              children: [
                                ListTile(
                                  trailing: IconButton(
                                    onPressed: () =>
                                        _confirmDelete(context, data['uuid']),
                                    icon: Icon(Icons.delete, color: Colors.red),
                                  ),
                                  leading: GestureDetector(
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          data['photo'] ?? "assets/logo.png"),
                                    ),
                                  ),
                                  title: Text(
                                    data['title'] ?? "No Title",
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  subtitle: Text(
                                    data['category'] ?? "No Subtitle",
                                    style: GoogleFonts.inter(
                                        color: Color(0xff9C9EA2),
                                        fontWeight: FontWeight.w300,
                                        fontSize: 15),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          "${getCurrencySymbol(data['currency'] ?? 'Euro')}${data['price'] ?? '0.0'}",
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                        Text(
                                          "Precio",
                                          style: GoogleFonts.inter(
                                              color: Color(0xff9C9EA2),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 19),
                                        ),
                                      ],
                                    ),
                                    Image.asset(
                                      "assets/line.png",
                                      height: 40,
                                      width: 52,
                                    ),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: yellow,
                                            ),
                                            Text(
                                              "${data['totalReviews'] ?? '0.0'}",
                                              style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          "${data['ratingCount'] ?? '0'} Reviews",
                                          style: GoogleFonts.inter(
                                              color: Color(0xff9C9EA2),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 19),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        }),
                  );
                }),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text("Are you sure you want to delete this service?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection("services")
                    .doc(docId)
                    .delete();
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (builder) => WebHome()),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
