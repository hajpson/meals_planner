import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/MealModel.dart';

// Client prepareClient() {
//   Client client = Client();

//   client
//   .setEndpoint(API_URL)
//   .setProject(PROJECT_ID)
//   .setSelfSigned(status: true);

//   return client;
// }

Future<Isar> initializeIsar() async {
  final directory = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [MealModelSchema],
    directory: directory.path
  );

  return isar;
}
