import 'package:flutter_test/flutter_test.dart';
import 'package:lumen_app/src/storage/in_memory_app_database.dart';
import 'package:lumen_app/src/storage/module_data_repository.dart';

void main() {
  test('a written document is read back, also by a new repository', () async {
    final database = InMemoryAppDatabase();
    final first = ModuleDataRepository(database);
    await first.write('memory', {
      'people': [1, 2],
    });
    expect(first.read('memory')['people'], [1, 2]);

    final second = ModuleDataRepository(database);
    await second.load(['memory', 'family']);
    expect(second.read('memory')['people'], [1, 2]);
    expect(second.read('family'), isEmpty);
  });

  test('a document that is not valid JSON is dropped, not fatal', () async {
    final database = InMemoryAppDatabase();
    await database.saveModuleData('speech', '{broken');
    final repository = ModuleDataRepository(database);
    await repository.load(['speech']);
    expect(repository.read('speech'), isEmpty);
  });

  test('a document that is JSON but not an object is ignored', () async {
    final database = InMemoryAppDatabase();
    await database.saveModuleData('speech', '[1,2]');
    final repository = ModuleDataRepository(database);
    await repository.load(['speech']);
    expect(repository.read('speech'), isEmpty);
  });
}
