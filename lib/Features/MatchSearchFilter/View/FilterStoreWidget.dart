import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ViewModel/MatchSearchFilterViewModel.dart';

class FilterStoreWidget extends StatefulWidget {
  const FilterStoreWidget({super.key});

  @override
  State<FilterStoreWidget> createState() => _FilterStoreWidgetState();
}

class _FilterStoreWidgetState extends State<FilterStoreWidget> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MatchSearchFilterViewModel>(context);
    return Container(
      color: Colors.yellow,
    );
  }
}
