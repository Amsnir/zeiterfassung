import 'package:flutter/material.dart';
import 'package:zeiterfassung_v1/buchen/buchen_page.dart';
import 'package:zeiterfassung_v1/hivedb/hivedb_test/dienstnehmerstammtest.dart';
import 'package:zeiterfassung_v1/hivedb/hivedb_test/dienstnehmertest.dart';
import 'package:zeiterfassung_v1/hivedb/hivefactory.dart';

class DynamicButtonsWidget extends StatefulWidget {
  const DynamicButtonsWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DynamicButtonsWidgetState createState() => _DynamicButtonsWidgetState();
}

class _DynamicButtonsWidgetState extends State<DynamicButtonsWidget> {
  late List<Dienstnehmerstamm> dienstnehmerstammList = [];
  late List<Dienstnehmer> dienstnehmerList = [];

  @override
  void initState() {
    super.initState();
    loadDienstnehmerData();
  }

  void loadDienstnehmerData() async {
    final dienstnehmerstammdaten =
        await HiveFactory.listBox<Dienstnehmerstamm>('dienstnehmerstammtest');
    final dienstnehmerdaten =
        await HiveFactory.listBox<Dienstnehmer>('dienstnehmertest');

    setState(() {
      dienstnehmerstammList = dienstnehmerstammdaten;
      dienstnehmerList = dienstnehmerdaten;
    });
  }

  Widget _buildButtons(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 300,
      child: ListView.builder(
        itemCount: dienstnehmerstammList.length,
        itemBuilder: (context, index) {
          final dienstnehmerstamm = dienstnehmerstammList[index];
          String buttonLabel =
              "${dienstnehmerstamm.nachname} ${dienstnehmerstamm.name}";
          return Container(
            width: screenWidth - 20, // Adjust based on your design
            padding: const EdgeInsets.symmetric(horizontal: 10),
            margin: const EdgeInsets.only(bottom: 10),
            child: ElevatedButton(
              onPressed: () {
                // Assuming dienstnehmerList[index] contains the corresponding Dienstnehmer data
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => BuchenPage(
                        dienstnehmer:
                            dienstnehmerList[index]), // Adjust this line
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                backgroundColor: Colors.grey,
                minimumSize:
                    Size(screenWidth - 40, 50), // Adjust based on your design
              ),
              child: Text(
                buttonLabel,
                style: const TextStyle(fontSize: 20.0, color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return dienstnehmerstammList.isEmpty
        ? const CircularProgressIndicator()
        : _buildButtons(context);
  }
}
