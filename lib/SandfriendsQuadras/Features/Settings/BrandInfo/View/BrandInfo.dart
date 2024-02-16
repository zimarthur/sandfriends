import 'package:flutter/material.dart';
import 'package:sandfriends_web/Features/Settings/BrandInfo/View/SFStorePhoto.dart';
import 'package:sandfriends_web/SharedComponents/View/SFAvatar.dart';
import 'package:sandfriends_web/SharedComponents/View/SFButton.dart';
import 'package:sandfriends_web/SharedComponents/View/SFTextfield.dart';
import 'package:sandfriends_web/Utils/Constants.dart';
import '../../../../SharedComponents/View/SFDivider.dart';
import '../../ViewModel/SettingsViewModel.dart';
import 'package:provider/provider.dart';

class BrandInfo extends StatefulWidget {
  SettingsViewModel viewModel;

  BrandInfo({super.key, required this.viewModel});

  @override
  State<BrandInfo> createState() => _BrandInfoState();
}

class _BrandInfoState extends State<BrandInfo> {
  final photosScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SettingsViewModel>(context);
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Logo do seu estabelecimento",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: defaultPadding,
                        ),
                        if (viewModel.isEmployeeAdmin)
                          Row(children: [
                            Expanded(
                              child: SFButton(
                                buttonLabel: "Escolher arquivo",
                                buttonType: ButtonType.Secondary,
                                onTap: () {
                                  viewModel.setStoreAvatar(context);
                                },
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                          ]),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: SFAvatar(
                        height: 160,
                        image: viewModel.storeEdit.logo,
                        editImage: viewModel.storeAvatar,
                        storeName: viewModel.storeEdit.name,
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: defaultPadding),
                child: SFDivider(),
              ),
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Descrição",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "(Todos os jogadores que entrarem na sua página irão ver essa descrição. Seja criativo!)",
                              style: TextStyle(
                                color: textDarkGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SFTextField(
                              labelText: "",
                              pourpose: TextFieldPourpose.Multiline,
                              controller: viewModel.descriptionController,
                              validator: (a) {
                                return null;
                              },
                              minLines: 5,
                              maxLines: 5,
                              hintText:
                                  "Fale sobre seu estabelecimento, infraestrutura, estacionamento...",
                              onChanged: (newValue) =>
                                  viewModel.onChangedDescription(newValue),
                              enable: viewModel.isEmployeeAdmin,
                            ),
                            Text(
                              "${viewModel.descriptionLength}/255",
                              style: const TextStyle(color: textDarkGrey),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Instagram",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "(Link para sua página)",
                              style: TextStyle(
                                color: textDarkGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            Expanded(
                              child: SFTextField(
                                controller: viewModel.instagramController,
                                labelText: "",
                                pourpose: TextFieldPourpose.Standard,
                                validator: (value) {
                                  return null;
                                },
                                prefixText: "www.instagram.com/",
                                onChanged: (newValue) =>
                                    viewModel.onChangedInstagram(newValue),
                                enable: viewModel.isEmployeeAdmin,
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: defaultPadding),
                child: SFDivider(),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Fotos da sua quadra",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          "(mín. 2)",
                          style: TextStyle(color: textDarkGrey),
                        ),
                        const SizedBox(
                          height: defaultPadding,
                        ),
                        if (viewModel.isEmployeeAdmin)
                          Row(children: [
                            Expanded(
                              child: SFButton(
                                buttonLabel: "Adicionar foto",
                                buttonType: ButtonType.Secondary,
                                onTap: () {
                                  viewModel.addStorePhoto(context);
                                },
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                          ]),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: viewModel.storeEdit.photos.isEmpty
                        ? Container()
                        : Scrollbar(
                            controller: photosScrollController,
                            child: Container(
                              height: 230,
                              margin: EdgeInsets.only(bottom: 12),
                              child: ListView.builder(
                                shrinkWrap: true,
                                controller: photosScrollController,
                                itemCount: viewModel.storeEdit.photos.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return StorePhotoCard(
                                    storePhoto:
                                        viewModel.storeEdit.photos[index],
                                    delete: () {
                                      viewModel.deleteStorePhoto(
                                        viewModel.storeEdit.photos[index]
                                            .idStorePhoto,
                                      );
                                    },
                                    isAdmin: viewModel.isEmployeeAdmin,
                                  );
                                },
                              ),
                            ),
                          ),
                  ),
                ],
              ),
              const SizedBox(
                height: 2 * defaultPadding,
              )
            ],
          ),
        ),
      ],
    );
  }
}
