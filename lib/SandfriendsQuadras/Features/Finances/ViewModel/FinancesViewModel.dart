import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../Common/Components/DatePickerModal.dart';
import '../../../../Common/Components/SFPieChart.dart';
import '../../../../Common/Enum/EnumPeriodVisualization.dart';
import '../../../../Common/Model/AppMatch/AppMatchStore.dart';
import '../../../../Common/Model/SandfriendsQuadras/SFBarChartItem.dart';
import '../../../../Common/Providers/Categories/CategoriesProvider.dart';
import '../../../../Common/Providers/Environment/EnvironmentProvider.dart';
import '../../../../Common/StandardScreen/StandardScreenViewModel.dart';
import '../../../../Common/Utils/Constants.dart';
import '../../../../Common/Utils/SFDateTime.dart';
import '../../../../Remote/NetworkResponse.dart';
import '../../Menu/ViewModel/StoreProvider.dart';
import '../../Menu/ViewModel/MenuProviderQuadras.dart';
import '../Model/FinancesDataSource.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;
import 'package:collection/collection.dart';

import '../Repository/FinancesRepo.dart';

class FinancesViewModel extends ChangeNotifier {
  final financesRepo = FinancesRepo();

  void initFinancesScreen(BuildContext context) {
    _matches = Provider.of<StoreProvider>(context, listen: false)
        .matches
        .where((match) => match.blocked == false)
        .toList();
    setFinancesDataSource();
  }

  EnumPeriodVisualization periodVisualization = EnumPeriodVisualization.Today;
  void setPeriodVisualization(
      BuildContext context, EnumPeriodVisualization newPeriodVisualization) {
    if (newPeriodVisualization == EnumPeriodVisualization.Custom) {
      setCustomPeriod(context);
    } else {
      periodVisualization = newPeriodVisualization;
      setFinancesDataSource();
      notifyListeners();
    }
  }

  void setCustomPeriod(BuildContext context) {
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .addOverlayWidget(
      DatePickerModal(
        onDateSelected: (dateStart, dateEnd) {
          customStartDate = dateStart;
          customEndDate = dateEnd;
          searchCustomMatches(context);
        },
        onReturn: () =>
            Provider.of<StandardScreenViewModel>(context, listen: false)
                .closeModal(),
      ),
    );
  }

  void searchCustomMatches(BuildContext context) {
    Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();
    financesRepo
        .searchCustomMatches(
            context,
            Provider.of<EnvironmentProvider>(context, listen: false)
                .accessToken!,
            customStartDate!,
            customEndDate)
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        Map<String, dynamic> responseBody = json.decode(
          response.responseBody!,
        );
        customMatches.clear();
        for (var match in responseBody['Matches']) {
          customMatches.add(
            AppMatchStore.fromJson(
              match,
              Provider.of<CategoriesProvider>(context, listen: false).hours,
              Provider.of<CategoriesProvider>(context, listen: false).sports,
            ),
          );
        }
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .closeModal();
        periodVisualization = EnumPeriodVisualization.Custom;
        setFinancesDataSource();
        notifyListeners();
      } else if (response.responseStatus ==
          NetworkResponseStatus.expiredToken) {
        Provider.of<MenuProviderQuadras>(context, listen: false)
            .logout(context);
      } else {
        Provider.of<MenuProviderQuadras>(context, listen: false)
            .setMessageModalFromResponse(context, response);
      }
    });
  }

  List<AppMatchStore> _matches = [];
  List<AppMatchStore> customMatches = [];
  List<AppMatchStore> get matches {
    List<AppMatchStore> filteredMatches = [];
    if (periodVisualization == EnumPeriodVisualization.Today) {
      filteredMatches = _matches
          .where(
            (match) =>
                areInTheSameDay(match.date, DateTime.now()) &&
                match.matchCreator.fullName.toLowerCase().contains(
                      playerFilter,
                    ),
          )
          .toList();
    } else if (periodVisualization == EnumPeriodVisualization.CurrentMonth) {
      filteredMatches = _matches
          .where(
            (match) =>
                isInCurrentMonth(match.date) &&
                match.matchCreator.fullName.toLowerCase().contains(
                      playerFilter,
                    ),
          )
          .toList();
    } else {
      filteredMatches = customMatches
          .where(
            (match) => match.matchCreator.fullName.toLowerCase().contains(
                  playerFilter,
                ),
          )
          .toList();
    }
    filteredMatches.sort((a, b) => a.date.compareTo(b.date));
    return filteredMatches;
  }

  String playerFilter = "";
  void updatePlayerFilter(String text) {
    playerFilter = text;
    notifyListeners();
  }

  bool _showNetCost = false;
  bool get showNetCost => _showNetCost;
  void setShowNetCost(bool newValue) {
    _showNetCost = newValue;
    setFinancesDataSource();
    notifyListeners();
  }

  double get revenue {
    return matches.isEmpty
        ? 0
        : matches
            .where((match) => match.date.isBefore(DateTime.now()))
            .toList()
            .fold(0,
                (sum, item) => sum + (showNetCost ? item.netCost : item.cost));
  }

  String get revenueTitle {
    String titleDate;
    if (periodVisualization == EnumPeriodVisualization.Today) {
      titleDate = "hoje";
    } else if (periodVisualization == EnumPeriodVisualization.CurrentMonth) {
      titleDate =
          "${monthsPortuguese[getSFMonthIndex(DateTime.now())]}/${DateTime.now().year}";
    } else {
      titleDate = customDateTitle!;
    }
    return "Faturamento $titleDate";
  }

  double get expectedRevenue {
    return matches.fold(
        0, (sum, item) => sum + (showNetCost ? item.netCost : item.cost));
  }

  String get expectedRevenueTitle {
    String titleDate;
    if (periodVisualization == EnumPeriodVisualization.Today) {
      titleDate = "final do dia";
    } else if (periodVisualization == EnumPeriodVisualization.CurrentMonth) {
      titleDate = "final do mês";
    } else {
      titleDate = customEndDate != null
          ? "até ${DateFormat('dd/MM').format(customEndDate!)}"
          : DateFormat('dd/MM').format(customStartDate!);
    }
    return "Previsão de faturamento $titleDate";
  }

  DateTime? customStartDate;
  DateTime? customEndDate;
  String? get customDateTitle {
    if (customStartDate != null) {
      if (customEndDate == null) {
        return DateFormat("dd/MM/yy").format(customStartDate!);
      } else {
        return "${DateFormat("dd/MM/yy").format(customStartDate!)} - ${DateFormat("dd/MM/yy").format(customEndDate!)}";
      }
    }
    return null;
  }

  List<SFBarChartItem> get barChartItems {
    List<SFBarChartItem> a = matches
        .map(
          (match) => SFBarChartItem(
            date: match.date,
            amount: (showNetCost ? match.netCost.toInt() : match.cost.toInt()),
          ),
        )
        .toList();

    return a;
  }

  double get revenueFromMatch {
    return matches.where((match) => !match.isFromRecurrentMatch).toList().fold(
        0,
        (previousValue, element) =>
            previousValue + (showNetCost ? element.netCost : element.cost));
  }

  double get revenueFromRecurrentMatch {
    return matches.where((match) => match.isFromRecurrentMatch).toList().fold(
        0,
        (previousValue, element) =>
            previousValue + (showNetCost ? element.netCost : element.cost));
  }

  int get revenueFromMatchPercentage {
    return expectedRevenue == 0
        ? 0
        : (revenueFromMatch * 100) ~/ expectedRevenue;
  }

  int get revenueFromRecurrentMatchPercentage {
    return expectedRevenue == 0
        ? 0
        : (revenueFromRecurrentMatch * 100) ~/ expectedRevenue;
  }

  //////// TABLE ////////////////////////////////////////
  FinancesDataSource? financesDataSource;

  void setFinancesDataSource() {
    financesDataSource =
        FinancesDataSource(matches: matches, showNetValue: showNetCost);
  }
  ///////////////////////////////////////////////////////

  /////////// PIE CHART ////////////////////////////////////
  List<PieChartItem> get pieChartItems {
    List<PieChartItem> items = [];
    Map<String, int> nameCount = <String, int>{};
    nameCount["Mensalista"] = revenueFromRecurrentMatch.toInt();
    nameCount["Avulso"] = revenueFromMatch.toInt();

    nameCount.forEach((key, value) {
      if (value > 0) {
        items.add(
          PieChartItem(
            name: key,
            value: value.toDouble(),
            isPrice: true,
            color: key == "Mensalista" ? primaryLightBlue : primaryBlue,
          ),
        );
      }
    });
    if (hoveredItem >= 0) {
      PieChartItem auxItem;
      auxItem = items[0];
      items[0] = items[hoveredItem];
      items[hoveredItem] = auxItem;
    }
    return items;
  }

  int _hoveredItem = -1;
  int get hoveredItem => _hoveredItem;
  set hoveredItem(int value) {
    _hoveredItem = value;
    notifyListeners();
  }

  ///////////////////////////////////////////////////////
}
