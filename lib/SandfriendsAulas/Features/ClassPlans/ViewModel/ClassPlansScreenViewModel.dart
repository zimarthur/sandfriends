import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Enum/EnumClassFormat.dart';
import 'package:sandfriends/Common/Enum/EnumClassFrequency.dart';
import 'package:sandfriends/Common/Model/ClassPlan.dart';
import 'package:sandfriends/Common/Providers/Drawer/EnumDrawerPage.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import 'package:sandfriends/Remote/NetworkResponse.dart';
import 'package:sandfriends/Sandfriends/Providers/TeacherProvider/TeacherProvider.dart';
import 'package:sandfriends/Sandfriends/Providers/UserProvider/UserProvider.dart';
import 'package:sandfriends/SandfriendsAulas/Features/ClassPlans/Repo/ClassPlansRepo.dart';
import 'package:sandfriends/SandfriendsAulas/Providers/MenuProviderAulas.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../../Common/Components/Modal/SFModalMessage.dart';

class ClassPlansScreenAulasViewModel extends MenuProviderAulas {
  final classPlansRepo = ClassPlansRepo();

  void initClassPlansViewModel(BuildContext context) {
    initMenuProviderAulas(
      context,
      DrawerPage.ClassPlans,
    );
  }

  TextEditingController priceController = TextEditingController();

  bool get isEditingPlan {
    if (currentPlan == null) {
      return false;
    }
    return currentPlan!.idClassPlan != null;
  }

  ClassPlan? currentPlan;
  void setCurrentPlan({ClassPlan? editPlan}) {
    if (editPlan != null) {
      if (isSamePlanId(editPlan)) {
        currentPlan = null;
        notifyListeners();
      } else {
        currentPlan = ClassPlan.copyFrom(editPlan);
        priceController.text = currentPlan!.price.toString();
      }
    } else {
      currentPlan = ClassPlan(
          idClassPlan: null,
          format: EnumClassFormat.Group,
          classFrequency: EnumClassFrequency.OnceWeek,
          price: 0);
      priceController.text = currentPlan!.price.toString();
    }
    notifyListeners();
  }

  bool isSamePlanId(ClassPlan plan) {
    if (currentPlan == null) {
      return false;
    }
    return currentPlan!.idClassPlan == plan.idClassPlan;
  }

  void closeAddPlan() {
    currentPlan = null;
    notifyListeners();
  }

  void setClassFormat(EnumClassFormat format) {
    if (currentPlan != null) {
      currentPlan!.format = format;
      notifyListeners();
    }
  }

  void setClassFrequency(EnumClassFrequency frequency) {
    if (currentPlan != null) {
      currentPlan!.classFrequency = frequency;
      notifyListeners();
    }
  }

  void setClassPrice(int price) {
    if (currentPlan != null) {
      currentPlan!.price = price;
      notifyListeners();
    }
  }

  void deletePlan(BuildContext context) {
    if (currentPlan == null) {
      return;
    }
    Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();
    classPlansRepo
        .deleteClassPlan(
      context,
      Provider.of<UserProvider>(context, listen: false).user!.accessToken,
      currentPlan!,
    )
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        Provider.of<TeacherProvider>(context, listen: false).deleteClassPlan(
          currentPlan!,
        );
        currentPlan = null;
        notifyListeners();
      } else {
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .addModalMessage(
          SFModalMessage(
            title: response.responseTitle!,
            onTap: () {
              if (response.responseStatus ==
                  NetworkResponseStatus.expiredToken) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login_signup',
                  (Route<dynamic> route) => false,
                );
              }
            },
            isHappy: false,
          ),
        );
      }
      FocusScope.of(context).unfocus();
      Provider.of<StandardScreenViewModel>(context, listen: false)
          .setPageStatusOk();
    });
  }

  void savePlan(BuildContext context) {
    if (isEditingPlan) {
      editClassPlan(context);
    } else {
      addClassPlan(context);
    }
  }

  void editClassPlan(BuildContext context) {
    if (currentPlan == null) {
      return;
    }
    int? parsedController = int.tryParse(priceController.text);
    if (parsedController == null || parsedController == 0) {
      Provider.of<StandardScreenViewModel>(context, listen: false)
          .addModalMessage(
        SFModalMessage(
          title: "Insira um preço válido",
          onTap: () {},
          isHappy: false,
        ),
      );
      return;
    }
    currentPlan!.price = parsedController;
    Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();
    classPlansRepo
        .editClassPlan(
      context,
      Provider.of<UserProvider>(context, listen: false).user!.accessToken,
      currentPlan!,
    )
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        Map<String, dynamic> responseBody = json.decode(
          response.responseBody!,
        );
        Provider.of<TeacherProvider>(context, listen: false).editClassPlan(
          ClassPlan.fromJson(
            responseBody["EditPlan"],
          ),
        );
        currentPlan = null;
        notifyListeners();
      } else {
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .addModalMessage(
          SFModalMessage(
            title: response.responseTitle!,
            onTap: () {
              if (response.responseStatus ==
                  NetworkResponseStatus.expiredToken) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login_signup',
                  (Route<dynamic> route) => false,
                );
              }
            },
            isHappy: false,
          ),
        );
      }
      FocusScope.of(context).unfocus();
      Provider.of<StandardScreenViewModel>(context, listen: false)
          .setPageStatusOk();
    });
  }

  void addClassPlan(BuildContext context) {
    if (currentPlan == null) {
      return;
    }
    int? parsedController = int.tryParse(priceController.text);
    if (parsedController == null || parsedController == 0) {
      Provider.of<StandardScreenViewModel>(context, listen: false)
          .addModalMessage(
        SFModalMessage(
          title: "Insira um preço válido",
          onTap: () {},
          isHappy: false,
        ),
      );
      return;
    }
    currentPlan!.price = parsedController;
    Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();
    classPlansRepo
        .addClassPlan(
      context,
      Provider.of<UserProvider>(context, listen: false).user!.accessToken,
      currentPlan!,
    )
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        Map<String, dynamic> responseBody = json.decode(
          response.responseBody!,
        );
        Provider.of<TeacherProvider>(context, listen: false).addClassPlan(
          ClassPlan.fromJson(
            responseBody["NewPlan"],
          ),
        );
        currentPlan = null;
        notifyListeners();
      } else {
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .addModalMessage(
          SFModalMessage(
            title: response.responseTitle!,
            onTap: () {
              if (response.responseStatus ==
                  NetworkResponseStatus.expiredToken) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login_signup',
                  (Route<dynamic> route) => false,
                );
              }
            },
            isHappy: false,
          ),
        );
      }
      FocusScope.of(context).unfocus();
      Provider.of<StandardScreenViewModel>(context, listen: false)
          .setPageStatusOk();
    });
  }
}
