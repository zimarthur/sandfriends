import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Model/User/UserComplete.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';

import '../../../../Components/SFAvatarUser.dart';
import '../../../../Components/SFButton.dart';
import '../../../../Utils/Constants.dart';

import '../../ViewModel/UserDetailsViewModel.dart';

class UserDetailsModalPhoto extends StatefulWidget {
  final UserDetailsViewModel viewModel;
  const UserDetailsModalPhoto({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  State<UserDetailsModalPhoto> createState() => _UserDetailsModalPhotoState();
}

class _UserDetailsModalPhotoState extends State<UserDetailsModalPhoto> {
  late bool noImage;
  late String? imagePicker;
  late UserComplete userEdited;

  @override
  void initState() {
    noImage = widget.viewModel.noImage;
    imagePicker = widget.viewModel.imagePicker;
    userEdited = widget.viewModel.userEdited;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.04,
        vertical: height * 0.04,
      ),
      decoration: BoxDecoration(
        color: secondaryPaper,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryDarkBlue, width: 1),
        boxShadow: const [BoxShadow(blurRadius: 1, color: primaryDarkBlue)],
      ),
      width: width * 0.9,
      height: width * 1.2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            "Toque para escolher uma nova foto.",
            style: TextStyle(color: textDarkGrey),
          ),
          Column(
            children: [
              SFAvatarUser(
                height: width * 0.7,
                user: userEdited,
                showRank: false,
                editFile: imagePicker,
                onTap: () => pickImage(),
              ),
              CheckboxListTile(
                title: const Text(
                  "Não escolher foto",
                  style: TextStyle(
                    color: textDarkGrey,
                  ),
                ),
                value: noImage,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (newValue) => setState(() {
                  if (newValue != null) {
                    imagePicker = null;
                    noImage = newValue;
                  }
                }),
              ),
            ],
          ),
          SFButton(
            buttonLabel: "Concluído",
            textPadding: EdgeInsets.symmetric(
              vertical: height * 0.01,
            ),
            onTap: () =>
                widget.viewModel.updateUserPhoto(context, noImage, imagePicker),
          ),
        ],
      ),
    );
  }

  Future pickImage() async {
    if (noImage) {
      return;
    }
    XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file == null) return;
    setState(() {
      imagePicker = file.path;
    });
  }
}
