import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kelimbo_admin/utils/color.dart';
import 'package:kelimbo_admin/widgets/logout_web_widget.dart';

class AccountWebPage extends StatefulWidget {
  const AccountWebPage({super.key});

  @override
  State<AccountWebPage> createState() => _AccountWebPageState();
}

class _AccountWebPageState extends State<AccountWebPage> {
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
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return LogoutWebWidget();
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
