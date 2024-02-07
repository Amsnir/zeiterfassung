import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';
import 'package:zeiterfassung_v1/api/apiHandler.dart';
import 'package:zeiterfassung_v1/hivedb/hivedb_Klassen/dienstnehmer.dart';
import 'package:zeiterfassung_v1/hivedb/hivefactory.dart';

void synchData() async {
  final dienstnehmer = new Dienstnehmer();

  // var data2 = await fetchBearerToken();
  // var data = await fetchDienstnehmer();
//  log(data.toString());
  dienstnehmer.DN_ID = 1;
  dienstnehmer.DN_FA_KZ = 'd';
  dienstnehmer.DN_FA_NR = 1;
  dienstnehmer.DN_NR = 4;
  dienstnehmer.DN_NAME = "Amir";
  dienstnehmer.DN_VORNAME = "Amir";
  dienstnehmer.DN_STATUS = 0;

  // final dienstnehmer2 = new Dienstnehmer();
  // dienstnehmer2.DN_ID = 2;
  // dienstnehmer2.DN_FA_KZ = 'd';
  // dienstnehmer2.DN_FA_NR = 1;
  // dienstnehmer2.DN_NR = 4;
  // dienstnehmer2.DN_NAME = "Moritz";
  // dienstnehmer2.DN_VORNAME = "Amir";
  // dienstnehmer2.DN_STATUS = 0;

  // final dienstnehmer3 = new Dienstnehmer();
  // dienstnehmer3.DN_ID = 3;
  // dienstnehmer3.DN_FA_KZ = 'd';
  // dienstnehmer3.DN_FA_NR = 1;
  // dienstnehmer3.DN_NR = 4;
  // dienstnehmer3.DN_NAME = "Janis";
  // dienstnehmer3.DN_VORNAME = "Amir";
  // dienstnehmer3.DN_STATUS = 0;

  // final dienstnehmerbox =
  //     await HiveFactory.openBox<Dienstnehmer>('dienstnehmer');
  // dienstnehmerbox.add(dienstnehmer);
  // dienstnehmerbox.add(dienstnehmer2);
  // dienstnehmerbox.add(dienstnehmer3);
}
