abstract class GenericLocalStorage {
  Future<dynamic> Function(String) get getValue;
  Function(String, dynamic) get setValue;
}
