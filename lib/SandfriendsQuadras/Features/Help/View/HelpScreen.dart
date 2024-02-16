import 'package:flutter/material.dart';
import 'package:sandfriends_web/Utils/Constants.dart';
import 'package:provider/provider.dart';
import '../../../SharedComponents/View/SFButton.dart';
import '../../../SharedComponents/View/SFHeader.dart';
import '../../Menu/ViewModel/MenuProvider.dart';

import '../ViewModel/HelpViewModel.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final HelpViewModel viewModel = HelpViewModel();

  final int _selectedTile = -1;

  @override
  Widget build(BuildContext context) {
    double width = Provider.of<MenuProvider>(context).getScreenWidth(context);
    double height = Provider.of<MenuProvider>(context).getScreenHeight(context);
    return ChangeNotifierProvider<HelpViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<HelpViewModel>(
        builder: (context, viewModel, _) {
          return Container(
            color: secondaryBack,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: SFHeader(
                        header: "Ajuda",
                        description:
                            "Tire suas dúvidas ou fale com a nossa equipe",
                      ),
                    ),
                    SFButton(
                      buttonLabel: "Conversar com o suporte",
                      buttonType: ButtonType.Primary,
                      onTap: () {
                        viewModel.talkSupport(context);
                      },
                      textPadding: const EdgeInsets.symmetric(
                        vertical: defaultPadding,
                        horizontal: defaultPadding * 2,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 2 * defaultPadding,
                ),
                const Text(
                  "Perguntas frequentes",
                  style: TextStyle(
                    color: textBlack,
                    fontSize: 22,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(
                  height: 2 * defaultPadding,
                ),
                Expanded(
                    child: ListView.builder(
                  itemCount: viewModel.faqItems.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ExpansionTile(
                          title: Text(
                            viewModel.faqItems[index].question,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: textBlack,
                            ),
                          ),
                          backgroundColor: secondaryPaper,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(defaultBorderRadius)),
                          childrenPadding: const EdgeInsets.all(defaultPadding),
                          children: [
                            ListTile(
                              title: Text(viewModel.faqItems[index].answer),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: defaultPadding,
                        )
                      ],
                    );
                  },
                )),
              ],
            ),
          );
        },
      ),
    );
  }
}
