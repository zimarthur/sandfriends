// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:sandfriends/Features/UserDetails/ViewModel/UserDetailsViewModel.dart';
// import 'package:sandfriends/SharedComponents/Model/Rank.dart';
// import 'package:sandfriends/SharedComponents/ViewModel/DataProvider.dart';

// import '../../../../SharedComponents/Model/Gender.dart';
// import '../../../../Utils/Constants.dart';
// import '../../../../Utils/Validators.dart';
// import '../../../../oldApp/widgets/SF_Button.dart';
// import '../../../../oldApp/widgets/SF_TextField.dart';

// class UserDetailsModalRank extends StatefulWidget {
//   UserDetailsViewModel viewModel;
//   UserDetailsModalRank({
//     required this.viewModel,
//   });

//   @override
//   State<UserDetailsModalRank> createState() => _UserDetailsModalRankState();
// }

// class _UserDetailsModalRankState extends State<UserDetailsModalRank> {
//   late Rank currentRank;

//   @override
//   void initState() {
//     currentRank = widget.viewModel.userEdited.ranks == null
//         ? Provider.of<DataProvider>(context, listen: false).genders.first
//         : widget.viewModel.userEdited.gender!;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;
//     return Container(
//       padding: EdgeInsets.symmetric(
//         horizontal: width * 0.04,
//         vertical: height * 0.04,
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           SizedBox(
//             height: height * 0.3,
//             child: ListView.builder(
//               shrinkWrap: true,
//               itemCount: Provider.of<DataProvider>(context, listen: false)
//                   .genders
//                   .length,
//               itemBuilder: (context, index) {
//                 return InkWell(
//                   onTap: () {
//                     setState(() {
//                       currentGender =
//                           Provider.of<DataProvider>(context, listen: false)
//                               .genders[index];
//                     });
//                   },
//                   child: Container(
//                     margin: EdgeInsets.only(bottom: height * 0.02),
//                     padding: EdgeInsets.symmetric(
//                         vertical: height * 0.02, horizontal: width * 0.05),
//                     decoration: BoxDecoration(
//                       color: secondaryBack,
//                       borderRadius: BorderRadius.circular(16),
//                       border: Border.all(
//                         color: currentGender ==
//                                 Provider.of<DataProvider>(context)
//                                     .genders[index]
//                             ? primaryBlue
//                             : textLightGrey,
//                         width: currentGender ==
//                                 Provider.of<DataProvider>(context)
//                                     .genders[index]
//                             ? 2
//                             : 1,
//                       ),
//                     ),
//                     child: Text(
//                       Provider.of<DataProvider>(context, listen: false)
//                           .genders[index]
//                           .name,
//                       style: TextStyle(
//                           color: currentGender ==
//                                   Provider.of<DataProvider>(context)
//                                       .genders[index]
//                               ? textBlue
//                               : textDarkGrey),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           SFButton(
//             buttonLabel: "Concluído",
//             buttonType: ButtonType.Primary,
//             textPadding: EdgeInsets.symmetric(
//               vertical: height * 0.02,
//             ),
//             onTap: () => widget.viewModel.setUserGender(currentGender),
//           )
//         ],
//       ),
//     );
//   }
// }
