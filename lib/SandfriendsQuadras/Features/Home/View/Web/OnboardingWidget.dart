import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../../Common/Utils/Constants.dart';
import '../../../Menu/ViewModel/MenuProvider.dart';
import '../../ViewModel/HomeViewModel.dart';
import 'OnboardingCheckItem.dart';

class OnboardingWidget extends StatelessWidget {
  HomeViewModel viewModel;
  OnboardingWidget({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (layoutContext, layoutConstraits) {
      return Container(
        height: 300,
        width: layoutConstraits.maxWidth,
        padding: const EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: secondaryPaper,
          borderRadius: BorderRadius.circular(
            defaultBorderRadius,
          ),
          boxShadow: const [
            BoxShadow(
              color: divider,
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: SvgPicture.asset(
                r"assets/people/onboarding.svg",
                height: 220,
                alignment: Alignment.center,
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Seja bem-vindo ao Sandfriends!",
                    style: TextStyle(
                      color: textBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  const Text(
                    "Preencha as informações essenciais do seu estabelecimento para começar a receber agendamentos",
                    style: TextStyle(
                      color: textDarkGrey,
                    ),
                  ),
                  Expanded(
                      child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            OnboardingCheckItem(
                              title: "Criar uma conta",
                              isChecked: true,
                              onTap: () {},
                            ),
                            OnboardingCheckItem(
                              title: "Adicionar o logo do seu estabelecimento",
                              isChecked: viewModel.logoSet(context),
                              onTap: () {
                                Provider.of<MenuProvider>(context,
                                        listen: false)
                                    .quickLinkBrand(context);
                              },
                            ),
                            OnboardingCheckItem(
                              title: "Adicionar fotos das suas quadras (mín 3)",
                              isChecked: viewModel.photosSet(context),
                              onTap: () {
                                Provider.of<MenuProvider>(context,
                                        listen: false)
                                    .quickLinkBrand(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            OnboardingCheckItem(
                              title:
                                  "Inserir uma descrição para o seu estabelecimento",
                              isChecked: viewModel.storeDescriptionSet(context),
                              onTap: () {
                                Provider.of<MenuProvider>(context,
                                        listen: false)
                                    .quickLinkBrand(context);
                              },
                            ),
                            OnboardingCheckItem(
                              title: "Cadastrar suas quadras",
                              isChecked: viewModel.courtsSet(context),
                              onTap: () {
                                Provider.of<MenuProvider>(context,
                                        listen: false)
                                    .quickLinkMyCourts(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
