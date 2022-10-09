import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/models/sport.dart';
import 'package:sandfriends/providers/categories_provider.dart';
import 'package:sandfriends/widgets/SFLoading.dart';
import 'package:sandfriends/widgets/SF_Button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/enums.dart';
import '../theme/app_theme.dart';
import '../providers/match_provider.dart';

class SportSelectionScreen extends StatefulWidget {
  @override
  State<SportSelectionScreen> createState() => _SportSelectionScreenState();
}

class _SportSelectionScreenState extends State<SportSelectionScreen> {
  bool isLoading = true;

  Future<void> RequestSports(BuildContext context) async {
    var response =
        await http.get(Uri.parse('https://www.sandfriends.com.br/GetSports'));
    if (response.statusCode == 200) {
      int sportIndex;
      String sportDescription;
      String sportPhoto;
      final responseBody = json.decode(response.body);
      for (int i = 0; i < responseBody.length; i++) {
        Map sport = responseBody[i];
        sportIndex = sport['IdSport'];
        sportDescription = sport['Description'];
        sportPhoto = sport['SportPhoto'];
        Provider.of<CategoriesProvider>(context, listen: false).addSport(Sport(
          idSport: sportIndex,
          description: sportDescription,
          photoUrl: sportPhoto,
        ));
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (Provider.of<CategoriesProvider>(context, listen: false)
        .sports
        .isEmpty) {
      RequestSports(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height - 75;
    return Container(
      color: AppTheme.colors.primaryBlue,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                  left: width * 0.1, right: width * 0.1, top: height * 0.1),
              width: width,
              height: height * 0.2,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Provider.of<CategoriesProvider>(context, listen: false)
                        .sports
                        .isEmpty
                    ? Expanded(
                        child: Center(
                          child: SFLoading(),
                        ),
                      )
                    : Text(
                        "O que você quer jogar?",
                        style: TextStyle(
                          color: AppTheme.colors.textWhite,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount:
                      Provider.of<CategoriesProvider>(context, listen: false)
                          .sports
                          .length,
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: height * 0.05,
                    );
                  },
                  itemBuilder: ((context, index) {
                    return Container(
                      height: height * 0.1,
                      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                      child: SFButton(
                          buttonLabel: Provider.of<CategoriesProvider>(context,
                                  listen: false)
                              .sports[index]
                              .description,
                          buttonType: ButtonType.Secondary,
                          textPadding:
                              EdgeInsets.symmetric(vertical: height * 0.025),
                          onTap: () {
                            if (Provider.of<MatchProvider>(context,
                                        listen: false)
                                    .selectedSport !=
                                Provider.of<CategoriesProvider>(context,
                                        listen: false)
                                    .sports[index]) {
                              Provider.of<MatchProvider>(context, listen: false)
                                  .ResetProviderAtributes();
                            }
                            Provider.of<MatchProvider>(context, listen: false)
                                    .selectedSport =
                                Provider.of<CategoriesProvider>(context,
                                        listen: false)
                                    .sports[index];
                            context.goNamed('match_search_screen');
                          }),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
