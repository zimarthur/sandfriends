import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../Common/StandardScreen/StandardScreenViewModel.dart';
import '../../Menu/ViewModel/MenuProvider.dart';
import '../Model/Faq.dart';
import '../View/TalkToSupportWidget.dart';

class HelpViewModel extends ChangeNotifier {
  List<Faq> faqItems = [
    Faq(
        question:
            "Tenho um jogador que ainda não baixou o app, posso registrar seus horários mesmo assim?",
        answer: "-"),
    Faq(question: "Preciso cancelar uma partida, o que eu faço?", answer: "-"),
    Faq(question: "Configurar o preço de mensalista", answer: "-"),
  ];

  void talkSupport(BuildContext context) {
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .addOverlayWidget(
      TalkToSupportWidget(),
    );
  }

  void returnMainView(BuildContext context) {
    Provider.of<StandardScreenViewModel>(context, listen: false).closeModal();
  }
}
