import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kelimbo_admin/screens/newcategoy.dart';
import 'package:kelimbo_admin/utils/color.dart';
import 'package:kelimbo_admin/widgets/logout_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset("assets/logo.png"),
            ),
            Card(
              child: ListTile(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (builder) => Newcategoy()));
                },
                title: Text(
                  "Categorías ",
                  style: GoogleFonts.workSans(
                      fontWeight: FontWeight.w500, fontSize: 16),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: colorBlack,
                ),
              ),
            ),
            Card(
              child: ListTile(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return LogoutWidget();
                    },
                  );
                },
                title: Text(
                  "Salir ",
                  style: GoogleFonts.workSans(
                      fontWeight: FontWeight.w500, fontSize: 16),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: colorBlack,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
