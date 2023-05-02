import 'package:flutter/material.dart';

import '../../oldApp/models/city.dart';
import '../../oldApp/models/region.dart';

class CitySelectorModal extends StatefulWidget {
  List<Region> regions;
  City selectedCity;
  CitySelectorModal({
    required this.regions,
    required this.selectedCity,
  });

  @override
  State<CitySelectorModal> createState() => _CitySelectorModalState();
}

class _CitySelectorModalState extends State<CitySelectorModal> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height * 0.7,
      child: ListView.builder(
        itemCount: widget.regions.length,
        itemBuilder: (BuildContext context, int index) {
          return ExpansionTile(
            title: Text(
              widget.regions[index].state,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            children: widget.regions[index].cities
                .map(
                  (city) => InkWell(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: height * 0.01),
                      child: Text(city.city),
                    ),
                    onTap: () {
                      setState(() {
                        for (var region in widget.regions) {
                          if (region.state == widget.regions[index].state) {
                            for (var cityList in region.cities) {
                              if (cityList.city == city.city) {
                                widget.selectedCity = City(
                                  cityId: cityList.cityId,
                                  city: cityList.city,
                                  state: Region(
                                      idState: widget.regions[index].idState,
                                      state: widget.regions[index].state,
                                      uf: widget.regions[index].uf),
                                );
                              }
                            }
                          }
                        }
                      });
                    },
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}
