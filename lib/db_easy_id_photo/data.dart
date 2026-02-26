import 'db_easy_id_photo_helper.dart';
import '../utils/logger.dart';

class DbInitializer {
  static Future<void> init() async {
    try {
      await DbHelper.database;
      Logger.i('Database initialized successfully');
    } catch (e) {
      Logger.e('Error initializing database', e);
    }
  }
}
