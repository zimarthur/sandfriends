import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

import '../../../../Common/Components/DatePickerModal.dart';
import '../../../../Common/Components/SFPieChart.dart';
import '../../../../Common/Enum/EnumPeriodVisualization.dart';
import '../../../../Common/Model/SandfriendsQuadras/Reward.dart';
import '../../../../Common/Model/SandfriendsQuadras/RewardItem.dart';
import '../../../../Common/Model/SandfriendsQuadras/SFBarChartItem.dart';
import '../../../../Common/Utils/SFDateTime.dart';
import '../../../../Remote/NetworkResponse.dart';
import '../../Menu/ViewModel/DataProvider.dart';
import '../../Menu/ViewModel/MenuProvider.dart';
import '../Model/RewardDataSource.dart';
import '../Repository/RewardsRepo.dart';
import '../View/Web/AddRewardModal.dart';
import '../View/Web/ChoseRewardModal.dart';

class RewardsViewModel extends ChangeNotifier {
  final rewardsRepo = RewardsRepo();

  EnumPeriodVisualization periodVisualization = EnumPeriodVisualization.Today;
  void setPeriodVisualization(
      BuildContext context, EnumPeriodVisualization newPeriodVisualization) {
    if (newPeriodVisualization == EnumPeriodVisualization.Custom) {
      setCustomPeriod(context);
    } else {
      periodVisualization = newPeriodVisualization;
      setRewardDataSource();
      notifyListeners();
    }
  }

  void setCustomPeriod(BuildContext context) {
    Provider.of<MenuProvider>(context, listen: false).setModalForm(
      DatePickerModal(
        onDateSelected: (dateStart, dateEnd) {
          customStartDate = dateStart;
          customEndDate = dateEnd;
          searchCustomRewards(context);
        },
        onReturn: () =>
            Provider.of<MenuProvider>(context, listen: false).closeModal(),
        allowFutureDates: false,
      ),
    );
  }

  String get rewardsPeriodTitle {
    String titleDate;
    if (periodVisualization == EnumPeriodVisualization.Today) {
      titleDate = "hoje";
    } else if (periodVisualization == EnumPeriodVisualization.CurrentMonth) {
      titleDate = "no mês";
    } else {
      titleDate = customEndDate != null
          ? "entre ${DateFormat('dd/MM').format(customStartDate!)} e ${DateFormat('dd/MM').format(customEndDate!)}"
          : "no dia ${DateFormat('dd/MM').format(customStartDate!)}";
    }
    return "Recompensas recolhidas\n$titleDate:";
  }

  int get rewardsCounter => rewards.length;

  List<Reward> _rewards = [];
  List<Reward> customRewards = [];

  List<Reward> get rewards {
    List<Reward> filteredRewards = [];
    if (periodVisualization == EnumPeriodVisualization.Today) {
      filteredRewards = _rewards
          .where(
            (reward) =>
                areInTheSameDay(reward.claimedDate, DateTime.now()) &&
                reward.player.fullName.toLowerCase().contains(
                      playerFilter,
                    ),
          )
          .toList();
    } else if (periodVisualization == EnumPeriodVisualization.CurrentMonth) {
      filteredRewards = _rewards
          .where(
            (reward) =>
                isInCurrentMonth(reward.claimedDate) &&
                reward.player.fullName.toLowerCase().contains(
                      playerFilter,
                    ),
          )
          .toList();
    } else {
      filteredRewards = customRewards
          .where(
            (reward) => reward.player.fullName.toLowerCase().contains(
                  playerFilter,
                ),
          )
          .toList();
    }

    filteredRewards.sort((a, b) => b.claimedDate.compareTo(a.claimedDate));
    return filteredRewards;
  }

  String playerFilter = "";
  void updatePlayerFilter(String text) {
    playerFilter = text;
    notifyListeners();
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

  List<RewardItem> possibleRewards = [];

  void initRewardsScreen(BuildContext context) {
    _rewards = Provider.of<DataProvider>(context, listen: false).rewards;
    setRewardDataSource();
  }

  void searchCustomRewards(BuildContext context) {
    Provider.of<MenuProvider>(context, listen: false).setModalLoading();
    rewardsRepo
        .searchCustomRewards(
            context,
            Provider.of<DataProvider>(context, listen: false).loggedAccessToken,
            customStartDate!,
            customEndDate)
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        Map<String, dynamic> responseBody = json.decode(
          response.responseBody!,
        );
        customRewards.clear();
        for (var reward in responseBody['Rewards']) {
          customRewards.add(
            Reward.fromJson(reward),
          );
        }
        Provider.of<MenuProvider>(context, listen: false).closeModal();
        periodVisualization = EnumPeriodVisualization.Custom;
        setRewardDataSource();
        notifyListeners();
      } else if (response.responseStatus ==
          NetworkResponseStatus.expiredToken) {
        Provider.of<MenuProvider>(context, listen: false).logout(context);
      } else {
        Provider.of<MenuProvider>(context, listen: false)
            .setMessageModalFromResponse(response);
      }
    });
  }

  void sendUserRewardCode(BuildContext context, String rewardCode) {
    Provider.of<MenuProvider>(context, listen: false).setModalLoading();
    rewardsRepo.sendUserRewardCode(context, rewardCode).then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        Map<String, dynamic> responseBody = json.decode(
          response.responseBody!,
        );
        possibleRewards.clear();
        for (var rewardItem in responseBody['RewardItems']) {
          possibleRewards.add(
            RewardItem.fromJson(rewardItem),
          );
        }
        setRewardsSelectorModal(context, rewardCode);
        notifyListeners();
      } else if (response.responseStatus ==
          NetworkResponseStatus.expiredToken) {
        Provider.of<MenuProvider>(context, listen: false).logout(context);
      } else {
        Provider.of<MenuProvider>(context, listen: false)
            .setMessageModalFromResponse(response);
      }
    });
  }

  void setRewardsSelectorModal(BuildContext context, String rewardCode) {
    Provider.of<MenuProvider>(context, listen: false)
        .setModalForm(ChoseRewardModal(
      rewardItems: possibleRewards,
      onReturn: () =>
          Provider.of<MenuProvider>(context, listen: false).closeModal(),
      onTapRewardItem: (rewardItem) {
        rewardsRepo
            .userRewardSelected(
                context,
                Provider.of<DataProvider>(context, listen: false)
                    .loggedAccessToken,
                rewardCode,
                rewardItem.idRewardItem)
            .then((response) {
          Provider.of<MenuProvider>(context, listen: false)
              .setMessageModalFromResponse(response);
        });
      },
    ));
  }

  /////////////ADD REWARD //////////////////////////////
  void addReward(BuildContext context) {
    Provider.of<MenuProvider>(context, listen: false).setModalForm(
      AddRewardModal(
        onSendRewardCode: (rewardCode) =>
            sendUserRewardCode(context, rewardCode),
        onReturn: () =>
            Provider.of<MenuProvider>(context, listen: false).closeModal(),
      ),
    );
  }

  void validateAddReward(BuildContext context) {
    Provider.of<MenuProvider>(context, listen: false).closeModal();
  }

  ///////////////////////////////////////////////////////

  //////// TABLE ////////////////////////////////////////
  RewardsDataSource? rewardsDataSource;

  void setRewardDataSource() {
    rewardsDataSource = RewardsDataSource(rewards: rewards);
  }
  ///////////////////////////////////////////////////////

  //////// PIE CHART ////////////////////////////////////
  List<PieChartItem> get pieChartItems {
    List<PieChartItem> items = [];
    Map<String, int> nameCount = <String, int>{};
    for (var object in rewards) {
      if (nameCount.containsKey(object.rewardItem.description)) {
        nameCount[object.rewardItem.description] =
            nameCount[object.rewardItem.description]! + 1;
      } else {
        nameCount[object.rewardItem.description] = 1;
      }
    }
    nameCount.forEach((key, value) {
      items.add(PieChartItem(name: key, value: value.toDouble()));
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

  List<SFBarChartItem> get barChartItems {
    return rewards
        .map((reward) => SFBarChartItem(date: reward.claimedDate, amount: 1))
        .toList();
  }
}
