import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Components/SFAvatarStore.dart';
import 'package:sandfriends/Common/Model/School.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';
import 'package:sandfriends/Common/Utils/TypeExtensions.dart';
import 'package:sandfriends/SandfriendsQuadras/Features/Classes/View/SchoolDetails.dart';
import 'package:sandfriends/SandfriendsQuadras/Features/Classes/ViewModel/ClassesViewModel.dart';
import 'package:sandfriends/SandfriendsQuadras/Features/Menu/ViewModel/StoreProvider.dart';

class SchoolsWidget extends StatelessWidget {
  ClassesViewModel viewModel;
  SchoolsWidget({required this.viewModel, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: Provider.of<StoreProvider>(context).schools.length,
      itemBuilder: (context, index) {
        School schoolItem = Provider.of<StoreProvider>(context).schools[index];
        return SchoolDetails(
            onTap: () => viewModel.onTapSchool(context, schoolItem),
            onEdit: () => viewModel.openAddOrEditSchooolModal(context,
                school: schoolItem),
            school: Provider.of<StoreProvider>(context).schools[index]);
      },
    );
  }
}
