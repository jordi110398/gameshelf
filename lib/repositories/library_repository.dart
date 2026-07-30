import 'package:gameshelf/models/library_game.dart';

abstract class LibraryRepository {

  Future<List<LibraryGame>> getLibrary();

  Future<void> addGame(LibraryGame game);

  Future<void> removeGame(int igdbId);

}