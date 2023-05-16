import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../Utils/Constants.dart';
import '../../../../oldApp/widgets/SFAvatar.dart';
import '../../../../oldApp/widgets/SF_Button.dart';
import '../../ViewModel/UserDetailsViewModel.dart';

class UserDetailsModalPhoto extends StatefulWidget {
  UserDetailsViewModel viewModel;
  UserDetailsModalPhoto({
    required this.viewModel,
  });

  @override
  State<UserDetailsModalPhoto> createState() => _UserDetailsModalPhotoState();
}

class _UserDetailsModalPhotoState extends State<UserDetailsModalPhoto> {
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
          Text(
            "Toque para escolher uma nova foto.",
            style: TextStyle(color: textDarkGrey),
          ),
          Column(
            children: [
              SFAvatar(
                height: width * 0.7,
                user: widget.viewModel.userEdited,
                showRank: false,
                editFile: widget.viewModel.imagePicker,
                onTap: () => pickImage(),
              ),
              CheckboxListTile(
                title: Text(
                  "Não escolher foto",
                  style: TextStyle(
                    color: textDarkGrey,
                  ),
                ),
                value: widget.viewModel.noImage,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (newValue) => setState(() {
                  widget.viewModel.noImage = newValue!;
                  widget.viewModel.imagePicker = null;
                }),
              ),
            ],
          ),
          SFButton(
            buttonLabel: "Concluído",
            buttonType: ButtonType.Primary,
            textPadding: EdgeInsets.symmetric(
              vertical: height * 0.01,
            ),
            onTap: () => widget.viewModel.closeModal(),
          ),
        ],
      ),
    );
  }

  Future pickImage() async {
    if (widget.viewModel.noImage) return;
    XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file == null) return;
    setState(() {
      widget.viewModel.imagePicker = file.path;
    });
  }
}
