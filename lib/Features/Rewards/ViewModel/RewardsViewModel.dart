import 'package:flutter/material.dart';

import '../../../SharedComponents/Model/ScreenInformation.dart';
import '../../../SharedComponents/View/Modal/SFModalMessage.dart';
import '../../../SharedComponents/View/Modal/ScreenInformationModal.dart';
import '../../../Utils/PageStatus.dart';
import '../Repository/RewardsRepoImp.dart';

class RewardsViewModel extends ChangeNotifier {
  final rewardsRepo = RewardsRepoImp();

  PageStatus pageStatus = PageStatus.OK;
  SFModalMessage modalMessage = SFModalMessage(
    message: "",
    onTap: () {},
    isHappy: true,
  );
  Widget? widgetForm;

  String titleText = "Recompensas";

  void closeModal() {
    pageStatus = PageStatus.OK;
    notifyListeners();
  }

  void onTapReturn(BuildContext context) {
    Navigator.pop(context);
  }

  void goToRewardsUserScreen(BuildContext context) {
    Navigator.pushNamed(context, '/rewards_user');
  }

  void showScreenInformationModal(BuildContext context) {
    widgetForm = ScreenInformationModal(
      title: "Recompensas",
      screenInformations: [
        ScreenInformation(
            question: "Como funcionam as recompensas?",
            answer:
                "Todo mês será lançado um desafio dentro do app. Complete-o e receba uma das recompensas disponíveis."),
        ScreenInformation(
            question:
                "Completei o desafio do mês, como faço para retirar a minha recompensa?",
            answer:
                'Basta mostrar o código da recompensa para o pessoal da quadra na sua próxima partida.'),
        ScreenInformation(
            question:
                "Por que meu agendamento pago no estabelecimento não contabilizou nas recompensas?",
            answer:
                "Somente agendamentos pagos pelo app (Pix ou cartão de crédito) contabilizam paras as recompensas."),
        ScreenInformation(
            question:
                "Entrar na partida de um amigo conta como um agendamento?",
            answer:
                "Não, o agendamento é contabilizado somenta para quem criou a partida."),
        ScreenInformation(
            question: "Posso retirar mais de uma recompensa pelo mês?",
            answer:
                'Não, cada jogador pode retirar, no máximo, uma recompensa ao mês.'),
      ],
      onReturn: () {
        closeModal();
      },
    );
    pageStatus = PageStatus.FORM;
    notifyListeners();
  }
}
