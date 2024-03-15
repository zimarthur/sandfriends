import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import 'package:sandfriends/Common/Model/ScreenInformation.dart';

import '../../../../Common/Components/Modal/ScreenInformationModal.dart';
import '../../../../Common/Utils/PageStatus.dart';
import '../Repository/RecurrentMatchesRepoImp.dart';

class RecurrentMatchesViewModel extends ChangeNotifier {
  final recurrentMatchesRepo = RecurrentMatchesRepoImp();

  int? _selectedRecurrentMatch;
  int? get selectedRecurrentMatch => _selectedRecurrentMatch;
  set selectedRecurrentMatch(int? newIndex) {
    _selectedRecurrentMatch = newIndex;
    notifyListeners();
  }

  void goToSearchType(BuildContext context) {
    Navigator.pushNamed(context, '/search_type', arguments: {
      'isRecurrent': true,
      'showReturnArrow': true,
    });
  }

  void showScreenInformationModal(BuildContext context) {
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .addOverlayWidget(
      ScreenInformationModal(
        title: "Mensalistas",
        screenInformations: [
          ScreenInformation(
              question: "Como funciona um horário mensalista?",
              answer:
                  "Se tornando um mensalista, você garante a reserva da quadra toda as semanas do mês, sempre no mesmo horário."),
          ScreenInformation(
              question: "Como é feito o pagamento do horário mensalista?",
              answer:
                  "Ao reservar um horário mensalista, é feito o pagamento integral do mês para garantir as reservas das quadras."),
          ScreenInformation(
              question:
                  "Posso cancelar uma única partida e continuar mensalista?",
              answer:
                  'Claro! Basta você entrar na partida que deseja cancelar e clicar em "Cancelar partida". Seu horário mensalista continuará ativo e você será reembolsado por esta partida.'),
          ScreenInformation(
              question: "Posso ser mensalista e pagar uma partida de cada vez?",
              answer:
                  "Não, para garantir que o horário seja reservado, você deve realizar o pagamento de todas as partidas do mês."),
          ScreenInformation(
              question: "Como eu cancelo um horário mensalista?",
              answer:
                  "Para cancelar, basta não fazer a renovação do horário. Ele será cancelado automaticamente."),
        ],
        onReturn: () {
          Provider.of<StandardScreenViewModel>(context, listen: false)
              .removeLastOverlay();
        },
      ),
    );
  }
}
