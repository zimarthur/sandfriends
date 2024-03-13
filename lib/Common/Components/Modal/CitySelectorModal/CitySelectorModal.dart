import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../Model/City.dart';
import '../../../Model/Region.dart';
import '../../../Utils/Constants.dart';
import '../../../Utils/PageStatus.dart';
import '../../SFButton.dart';
import '../../SFLoading.dart';
import '../../SFTextField.dart';
import 'CitySelectorViewModel.dart';

class CitySelectorModal extends StatefulWidget {
  final Function(City) onSelectedCity;
  final City? userCity;
  final Color themeColor;
  final VoidCallback onReturn;
  final bool onlyAvailableCities;

  const CitySelectorModal({
    Key? key,
    required this.onSelectedCity,
    required this.onReturn,
    this.userCity,
    this.themeColor = primaryBlue,
    required this.onlyAvailableCities,
  }) : super(key: key);

  @override
  State<CitySelectorModal> createState() => _CitySelectorModalState();
}

class _CitySelectorModalState extends State<CitySelectorModal> {
  TextEditingController searchController = TextEditingController();
  final FocusNode searchFocus = FocusNode();
  List<Region> filteredRegions = [];

  final viewModel = CitySelectorViewModel();
  @override
  void initState() {
    viewModel.initModal(
      context,
      widget.onlyAvailableCities,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(searchFocus);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ChangeNotifierProvider<CitySelectorViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<CitySelectorViewModel>(
        builder: (context, viewModel, _) {
          return Container(
            decoration: BoxDecoration(
              color: secondaryPaper,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: primaryDarkBlue, width: 1),
              boxShadow: const [
                BoxShadow(blurRadius: 1, color: primaryDarkBlue)
              ],
            ),
            padding: const EdgeInsets.all(
              defaultPadding,
            ),
            width: kIsWeb ? 600 : width * 0.9,
            height: height * 0.9,
            child: InkWell(
              onTap: () => FocusScope.of(context).unfocus(),
              child: viewModel.modalStatus == PageStatus.LOADING
                  ? SFLoading()
                  : Column(
                      children: [
                        SFTextField(
                          labelText: "Buscar cidade",
                          pourpose: TextFieldPourpose.Standard,
                          controller: searchController,
                          focusNode: searchFocus,
                          prefixIcon: SvgPicture.asset(
                            r"assets/icon/search.svg",
                            color: widget.themeColor,
                          ),
                          themeColor: widget.themeColor,
                          validator: (value) {
                            return null;
                          },
                          onChanged: (typed) {
                            setState(() {
                              filteredRegions.clear();
                              if (typed.isNotEmpty) {
                                for (var region in viewModel.regions) {
                                  for (var city in region.cities) {
                                    if (city.name
                                        .toLowerCase()
                                        .startsWith(typed.toLowerCase())) {
                                      Region? selectedRegion;
                                      if (filteredRegions.any(
                                        (regionLoop) =>
                                            region.idState ==
                                            regionLoop.idState,
                                      )) {
                                        selectedRegion =
                                            filteredRegions.firstWhere(
                                          (regionLoop) =>
                                              region.idState ==
                                              regionLoop.idState,
                                        );
                                      } else {
                                        Region newRegion = Region(
                                          idState: region.idState,
                                          state: region.state,
                                          uf: region.uf,
                                        );
                                        filteredRegions.add(newRegion);
                                        selectedRegion = newRegion;
                                      }
                                      selectedRegion.cities.add(city);
                                    }
                                  }
                                }
                              }
                            });
                          },
                        ),
                        filteredRegions.isEmpty
                            ? Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      if (widget.userCity != null &&
                                          viewModel.regions.any((region) =>
                                              region.cities.any((city) =>
                                                  city.cityId ==
                                                  widget.userCity!.cityId)))
                                        InkWell(
                                          onTap: () => widget.onSelectedCity(
                                            widget.userCity!,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: defaultPadding / 2,
                                                horizontal: defaultPadding),
                                            child: Row(
                                              children: [
                                                SvgPicture.asset(
                                                  r"assets/icon/location_ping.svg",
                                                  color: widget.themeColor,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    right: defaultPadding / 2,
                                                  ),
                                                ),
                                                Text(
                                                  "${widget.userCity!.name} / ${widget.userCity!.state!.uf}",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: widget.themeColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      for (var region in viewModel.regions)
                                        ExpansionTile(
                                          title: Text(
                                            region.state,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          children: [
                                            for (var city in region.cities)
                                              InkWell(
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: height * 0.01),
                                                  child: Text(city.name),
                                                  width: double.infinity,
                                                  alignment: Alignment.center,
                                                ),
                                                onTap: () =>
                                                    widget.onSelectedCity(
                                                  City(
                                                    cityId: city.cityId,
                                                    name: city.name,
                                                    state: region,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              )
                            : Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      for (var region in filteredRegions)
                                        for (var city in region.cities)
                                          InkWell(
                                            onTap: () => widget.onSelectedCity(
                                              City(
                                                cityId: city.cityId,
                                                name: city.name,
                                                state: region,
                                              ),
                                            ),
                                            child: SizedBox(
                                              height: 50,
                                              child: Column(
                                                children: [
                                                  Expanded(
                                                    child: Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        "${city.name} - ${region.uf}",
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 1,
                                                    width: double.infinity,
                                                    color: divider,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                    ],
                                  ),
                                ),
                              ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding),
                          child: SFButton(
                            buttonLabel: "Voltar",
                            isPrimary: false,
                            onTap: () => widget.onReturn(),
                            textPadding: EdgeInsets.symmetric(
                                vertical: defaultPadding / 2),
                          ),
                        )
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }
}
