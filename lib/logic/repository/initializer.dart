import 'package:appwrite/appwrite.dart';
import 'package:meals_planner/constants/appwrite_data.dart';

Client prepareClient() {
  Client client = Client();

  client
  .setEndpoint(API_URL)
  .setProject(PROJECT_ID)
  .setSelfSigned(status: true);

  return client;
}
