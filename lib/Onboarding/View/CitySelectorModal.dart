import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/Utils/Constants.dart';
import 'package:sandfriends/oldApp/widgets/SF_TextField.dart';

import '../../SharedComponents/Model/City.dart';
import '../../SharedComponents/Model/Region.dart';

class CitySelectorModal extends StatefulWidget {
  List<Region> regions;
  Function(Region) onSelectedCity;
  CitySelectorModal({
    required this.regions,
    required this.onSelectedCity,
  });

  @override
  State<CitySelectorModal> createState() => _CitySelectorModalState();
}

class _CitySelectorModalState extends State<CitySelectorModal> {
  TextEditingController searchController = TextEditingController();
  List<Region> filteredRegions = [];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        color: secondaryPaper,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryDarkBlue, width: 1),
        boxShadow: [BoxShadow(blurRadius: 1, color: primaryDarkBlue)],
      ),
      width: width * 0.9,
      height: height * 0.9,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.02,
              vertical: width * 0.03,
            ),
            child: SFTextField(
              labelText: "Buscar cidade",
              pourpose: TextFieldPourpose.Standard,
              controller: searchController,
              prefixIcon: SvgPicture.asset(r"assets\icon\search.svg"),
              validator: (value) {},
              onChanged: (typed) {
                setState(() {
                  filteredRegions.clear();
                  if (typed.isNotEmpty) {
                    for (var region in widget.regions) {
                      for (var city in region.cities) {
                        if (city.city
                            .toLowerCase()
                            .startsWith(typed.toLowerCase())) {
                          Region? selectedRegion;
                          if (filteredRegions.any(
                            (regionLoop) =>
                                region.idState == regionLoop.idState,
                          )) {
                            selectedRegion = filteredRegions.firstWhere(
                              (regionLoop) =>
                                  region.idState == regionLoop.idState,
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
          ),
          filteredRegions.isEmpty
              ? Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for (var region in widget.regions)
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
                                    child: Text(city.city),
                                  ),
                                  onTap: () => widget.onSelectedCity(
                                    Region(
                                      idState: region.idState,
                                      state: region.state,
                                      uf: region.uf,
                                      selectedCity: city,
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
                                Region(
                                  idState: region.idState,
                                  state: region.state,
                                  uf: region.uf,
                                  selectedCity: city,
                                ),
                              ),
                              child: SizedBox(
                                height: 50,
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "${city.city} - ${region.uf}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
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
                )
        ],
      ),
    );
  }
}
