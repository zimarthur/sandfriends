import '../../../Remote/NetworkResponse.dart';

class NewCreditCardRepo {
  Future<NetworkResponse?> addUserCreditCard(
    String accessToken,
    String cardNumber,
    String cvv,
    String nickname,
    DateTime expirationDate,
    String ownerName,
    String ownerCpf,
    String cep,
    String address,
    String addressNumber,
  ) async {
    return null;
  }
}
