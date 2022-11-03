import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/models/recurrent_match.dart';
import 'package:sandfriends/widgets/SF_Button.dart';
import 'package:sandfriends/widgets/SF_Scaffold.dart';
import 'package:http/http.dart' as http;

import '../models/enums.dart';
import '../providers/categories_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/SFLoading.dart';

class RecurrentMatchScreen extends StatefulWidget {
  const RecurrentMatchScreen({Key? key}) : super(key: key);

  @override
  State<RecurrentMatchScreen> createState() => _RecurrentMatchScreenState();
}

class _RecurrentMatchScreenState extends State<RecurrentMatchScreen> {
  bool showModal = false;
  bool isLoading = false;

  List<RecurrentMatch> recurrentMatches = [];

  @override
  void initState() {
    GetRecurrentMatches();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        context.goNamed('home', params: {'initialPage': 'feed_screen'});
        return false;
      },
      child: Scaffold(
        body: Container(
          color: AppTheme.colors.secondaryBack,
          child: isLoading
              ? Stack(
                  children: [
                    Container(
                      color: AppTheme.colors.secondaryBack,
                    ),
                    Container(
                      //loading
                      color: AppTheme.colors.primaryBlue.withOpacity(0.3),
                      child: const Center(
                        child: SFLoading(),
                      ),
                    )
                  ],
                )
              : Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).padding.top + height * 0.2,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppTheme.colors.secondaryLightBlue,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30.0),
                          bottomRight: Radius.circular(30.0),
                        ),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.symmetric(
                                    vertical: height * 0.01,
                                    horizontal: width * 0.02,
                                  ),
                                  child: InkWell(
                                    onTap: () => context.goNamed('home',
                                        params: {'initialPage': 'feed_screen'}),
                                    child: Container(
                                      height: width * 0.1,
                                      width: width * 0.1,
                                      padding: EdgeInsets.all(width * 0.02),
                                      decoration:
                                          BoxDecoration(shape: BoxShape.circle),
                                      child: SvgPicture.asset(
                                        r'assets\icon\arrow_left.svg',
                                        color: AppTheme.colors.secondaryBack,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: height * 0.10,
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.1),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: height * 0.03,
                                        child: FittedBox(
                                          fit: BoxFit.fitHeight,
                                          child: Text(
                                            "Área do",
                                            style: TextStyle(
                                              color:
                                                  AppTheme.colors.textDarkGrey,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: height * 0.05,
                                        child: FittedBox(
                                          fit: BoxFit.fitHeight,
                                          child: Text(
                                            "Mensalista",
                                            style: TextStyle(
                                                color:
                                                    AppTheme.colors.textWhite,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.colors.secondaryBack,
                        border: Border(
                          bottom: BorderSide(
                            color: AppTheme.colors.divider.withOpacity(0.6),
                            width: 1,
                          ),
                        ),
                      ),
                      height: height * 0.1,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Horários",
                                  textScaleFactor: 0.9,
                                  style: TextStyle(
                                      color: AppTheme.colors.textDarkGrey),
                                ),
                                Text(
                                  recurrentMatches.isEmpty
                                      ? "-"
                                      : "${recurrentMatches.length}",
                                  textScaleFactor: 1.5,
                                  style: TextStyle(
                                      color: AppTheme.colors.secondaryLightBlue,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            color: AppTheme.colors.divider,
                            height: height * 0.06,
                            width: 1,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Vencimento",
                                  textScaleFactor: 0.9,
                                  style: TextStyle(
                                      color: AppTheme.colors.textDarkGrey),
                                ),
                                Text(
                                  recurrentMatches.isEmpty ? "-" : "Dia 31",
                                  textScaleFactor: 1.5,
                                  style: TextStyle(
                                      color: AppTheme.colors.secondaryLightBlue,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.05,
                          ),
                          color: AppTheme.colors.secondaryPaper,
                          child: recurrentMatches.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Você não tem nenhum horário mensalista.",
                                        style: TextStyle(
                                            color:
                                                AppTheme.colors.textDarkGrey),
                                      )
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: recurrentMatches.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: EdgeInsets.symmetric(
                                        vertical: height * 0.01,
                                      ),
                                      height: 140,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color:
                                              AppTheme.colors.primaryLightBlue,
                                          width: 1,
                                        ),
                                        color: AppTheme
                                            .colors.secondaryLightBlue
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 25,
                                            width: double.infinity,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: AppTheme
                                                  .colors.primaryLightBlue,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(15),
                                                topRight: Radius.circular(15),
                                              ),
                                            ),
                                            child: Text(
                                              "${Provider.of<CategoriesProvider>(context, listen: false).weekDaysPortuguese[recurrentMatches[index].weekday]}:  ${recurrentMatches[index].timeBegin} - ${recurrentMatches[index].timeEnd}",
                                              style: TextStyle(
                                                  color:
                                                      AppTheme.colors.textWhite,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 10),
                                              child: Row(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16.0),
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          recurrentMatches[
                                                                  index]
                                                              .court
                                                              .store
                                                              .imageUrl,
                                                      height: 80,
                                                      width: 80,
                                                      placeholder:
                                                          (context, url) =>
                                                              Container(
                                                        height: 80,
                                                        width: 80,
                                                        child: Center(
                                                          child: SFLoading(),
                                                        ),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Container(
                                                        height: 80,
                                                        width: 80,
                                                        color: AppTheme.colors
                                                            .textLightGrey
                                                            .withOpacity(0.5),
                                                        child: Center(
                                                          child: Icon(
                                                              Icons.dangerous),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                      right: 20,
                                                    ),
                                                  ),
                                                  Expanded(
                                                      child: Container(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            SvgPicture.asset(
                                                              r'assets\icon\location_ping.svg',
                                                              color: AppTheme
                                                                  .colors
                                                                  .textDarkGrey,
                                                              width: 15,
                                                            ),
                                                            Padding(
                                                                padding: EdgeInsets.only(
                                                                    right: width *
                                                                        0.02)),
                                                            Expanded(
                                                              child: Text(
                                                                recurrentMatches[
                                                                        index]
                                                                    .court
                                                                    .store
                                                                    .name,
                                                                style:
                                                                    TextStyle(
                                                                  color: AppTheme
                                                                      .colors
                                                                      .textDarkGrey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  "Partidas jogadas:",
                                                                  style:
                                                                      TextStyle(
                                                                    color: AppTheme
                                                                        .colors
                                                                        .textDarkGrey,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "${recurrentMatches[index].recurrentMatchesCounter}",
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: AppTheme
                                                                        .colors
                                                                        .textDarkGrey,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  "Mensalista desde: ",
                                                                  style:
                                                                      TextStyle(
                                                                    color: AppTheme
                                                                        .colors
                                                                        .textDarkGrey,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "${DateFormat("dd/MM/yyyy").format(recurrentMatches[index].creationDate)}",
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: AppTheme
                                                                        .colors
                                                                        .textDarkGrey,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                )),
                    ),
                    Container(
                      color: AppTheme.colors.secondaryPaper,
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.04, vertical: height * 0.02),
                      child: SFButton(
                        buttonLabel: "Buscar Quadras Mensalistas",
                        buttonType: ButtonType.LightBlue,
                        onTap: () {},
                        textPadding:
                            EdgeInsets.symmetric(vertical: height * 0.01),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Future<void> GetRecurrentMatches() async {
    setState(() {
      isLoading = true;
    });
    const storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: "AccessToken");
    bool isNewUser = false;

    if (accessToken != null) {
      var response = await http.post(
        Uri.parse('https://www.sandfriends.com.br/UserRecurrentMatches'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, Object>{
            'AccessToken': accessToken,
          },
        ),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        final responseRecurrentMatches = responseBody['RecurrentMatches'];

        for (int i = 0; i < responseRecurrentMatches.length; i++) {
          recurrentMatches
              .add(recurrentMatchFromJson(responseRecurrentMatches[i]));
        }

        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
