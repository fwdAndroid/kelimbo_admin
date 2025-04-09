import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kelimbo_admin/utils/color.dart';
import 'package:kelimbo_admin/utils/image_utils.dart';
import 'package:kelimbo_admin/widgets/save_button.dart';

class AddCategories extends StatefulWidget {
  const AddCategories({super.key});

  @override
  State<AddCategories> createState() => _AddCategoriesState();
}

class _AddCategoriesState extends State<AddCategories> {
  String dropdownvalue = 'Hogar';
  var items = [
    'Hogar',
    'Salud',
    'Turismo',
    'Entrenamiento',
    'Vehículos',
    'Mascotas',
    'Fotografía y video',
    'Eventos',
    'Belleza',
    'Limpieza',
    'Acompañamiento',
    'Recados',
    'Esoterismo',
    'Costura',
    'Asesoramiento',
    'Enseñanzas',
    'Crecimiento Personal',
    'Gestiones',
    'Tecnología',
    'Arte y Artesanía',
    'Grupos temáticos',
    'Otros'
  ];
  TextEditingController emailController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Image.asset(
            "assets/logo.png",
            height: 180,
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
            child: DropdownButton(
              value: dropdownvalue,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: items.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownvalue = newValue!;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.category,
                  color: iconColor,
                ),
                filled: true,
                fillColor: textColor,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(22)),
                    borderSide: BorderSide(
                      color: textColor,
                    )),
                border: InputBorder.none,
                hintText: "Agregar subcategorías",
                hintStyle: GoogleFonts.nunitoSans(
                  fontSize: 16,
                  color: iconColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: mainColor,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SaveButton(
                    title: "Agregar subcategorías",
                    onTap: () async {
                      if (emailController.text.isEmpty) {
                        showMessageBar(
                            "Se requiere al menos una subcategoría", context);
                      } else {
                        setState(() {
                          isLoading = true;
                        });

                        try {
                          String subcategoryInput = emailController.text.trim();

                          // Reference to the Firestore collection
                          CollectionReference categoriesRef = FirebaseFirestore
                              .instance
                              .collection('categories');

                          // Check if the category exists
                          QuerySnapshot querySnapshot = await categoriesRef
                              .where('category', isEqualTo: dropdownvalue)
                              .get();

                          if (querySnapshot.docs.isNotEmpty) {
                            // Category exists, update subcategories
                            DocumentSnapshot categoryDoc =
                                querySnapshot.docs.first;

                            List<dynamic> existingSubcategories =
                                categoryDoc['subcategories'] ?? [];
                            if (!existingSubcategories
                                .contains(subcategoryInput)) {
                              existingSubcategories.add(subcategoryInput);

                              await categoryDoc.reference.update({
                                'subcategories': existingSubcategories,
                                'updatedAt': FieldValue
                                    .serverTimestamp(), // Optional timestamp for updates
                              });

                              showMessageBar(
                                  "Subcategoría añadida correctamente",
                                  context);
                            } else {
                              showMessageBar(
                                  "La subcategoría ya existe", context);
                            }
                          } else {
                            // Category does not exist, create a new document
                            await categoriesRef.add({
                              'category': dropdownvalue,
                              'subcategories': [subcategoryInput],
                              'createdAt': FieldValue.serverTimestamp(),
                            });

                            showMessageBar(
                                "Categoría y subcategoría añadidas correctamente",
                                context);
                          }

                          emailController.clear(); // Clear input field
                        } catch (e) {
                          // Handle errors
                          showMessageBar(
                              "Error al guardar la subcategoría: $e", context);
                        } finally {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      }
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
