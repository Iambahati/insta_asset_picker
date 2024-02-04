
import 'package:flutter/material.dart';
import 'package:insta_asset_picker/assets_picker/shared/custom_picker.dart';

import 'shared/assets_page_mixin.dart';


class MultiAssetsPage extends StatefulWidget {
  final int maxAssetsCount;
  final Widget child;
  const MultiAssetsPage({super.key, required this.maxAssetsCount, required this.child});

  @override
  State<MultiAssetsPage> createState() => _MultiAssetsPageState();
}

class _MultiAssetsPageState extends State<MultiAssetsPage>
    with AutomaticKeepAliveClientMixin, AssetPickerMixin {
  @override
  int get maxAssetsCount => widget.maxAssetsCount;

  @override
  Widget get userSuppliedWidget => widget.child;


  @override
  bool get wantKeepAlive => true;

  @override
  PickMethod getPickMethod(BuildContext context) {
    return PickMethod.custom(context, maxAssetsCount);
  }
}