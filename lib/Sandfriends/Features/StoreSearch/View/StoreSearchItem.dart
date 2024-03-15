import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Model/Store/StoreUser.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../Common/Providers/Environment/EnvironmentProvider.dart';
import '../../../Providers/UserProvider/UserProvider.dart';
import '../../../../Common/Components/SFLoading.dart';

class StoreSearchItem extends StatelessWidget {
  const StoreSearchItem({
    super.key,
    required this.store,
  });

  final StoreUser store;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: defaultPadding / 2),
      height: 120,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                defaultBorderRadius,
              ),
              boxShadow: const [
                BoxShadow(
                  color: textDarkGrey,
                  blurRadius: 5,
                  offset: Offset(
                    2.0,
                    5.0,
                  ),
                ),
              ],
              image: DecorationImage(
                image: NetworkImage(
                  Provider.of<EnvironmentProvider>(context, listen: false)
                      .urlBuilder(
                    store.photos.first,
                    isImage: true,
                  ),
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              top: defaultPadding,
              left: defaultPadding / 2,
              right: defaultPadding / 2,
              bottom: defaultPadding / 2,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                defaultBorderRadius,
              ),
              color: textDarkGrey.withOpacity(0.8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            store.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: textWhite,
                              fontSize: 20,
                              overflow: TextOverflow.ellipsis,
                            ),
                            minFontSize: 16,
                            maxLines: 1,
                          ),
                          SizedBox(
                            height: defaultPadding / 4,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                r"assets/icon/location_ping.svg",
                                color: textWhite,
                              ),
                              SizedBox(
                                width: defaultPadding / 2,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      store.neighbourhoodAddress,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: textWhite,
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(
                                      height: defaultPadding / 4,
                                    ),
                                    if (Provider.of<UserProvider>(context,
                                                listen: false)
                                            .userLocation !=
                                        null)
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: defaultPadding / 2),
                                        decoration: BoxDecoration(
                                          color: textWhite,
                                          borderRadius: BorderRadius.circular(
                                            defaultBorderRadius,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "${(Geolocator.distanceBetween(Provider.of<UserProvider>(context).userLocation!.latitude, Provider.of<UserProvider>(context).userLocation!.longitude, store.latitude, store.longitude) / 1000).toStringAsFixed(2)} km",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: textDarkGrey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Ver horários disponíveis",
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 12,
                              color: textWhite,
                            ),
                          ),
                          SvgPicture.asset(
                            r"assets/icon/chevron_right.svg",
                            color: textWhite,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: defaultPadding / 2,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl:
                        Provider.of<EnvironmentProvider>(context, listen: false)
                            .urlBuilder(
                      store.logo!,
                      isImage: true,
                    ),
                    height: 85,
                    width: 85,
                    placeholder: (context, url) => SizedBox(
                      height: 85,
                      width: 85,
                      child: Center(
                        child: SFLoading(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 85,
                      width: 85,
                      color: textLightGrey.withOpacity(0.5),
                      child: const Center(
                        child: Icon(Icons.dangerous),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
