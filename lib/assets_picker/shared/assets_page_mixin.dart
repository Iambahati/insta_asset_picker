import 'package:flutter/material.dart';
import 'package:insta_asset_picker/assets_picker/shared/custom_picker.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart'
    show AssetEntity;

import '../widgets/actual_asset_picker_widget.dart';
import '../widgets/selected_assets_list_view.dart';

@optionalTypeArgs
mixin AssetPickerMixin<T extends StatefulWidget> on State<T> {
  final ValueNotifier<bool> isDisplayingDetail = ValueNotifier<bool>(true);

  @override
  void dispose() {
    isDisplayingDetail.dispose();
    super.dispose();
  }

  int get maxAssetsCount;

  List<AssetEntity> selectedAssets = <AssetEntity>[];

  PickMethod getPickMethod(BuildContext context);

  Widget get userSuppliedWidget;

  Future<void> selectAssets(PickMethod pickMethod) async {
    final List<AssetEntity>? result =
        await pickMethod.method(context, selectedAssets);
    if (result != null) {
      selectedAssets = result.toList();
      if (mounted) {
        setState(() {});
      }
    }
  }

  void removeAsset(int index) {
    selectedAssets.removeAt(index);
    if (selectedAssets.isEmpty) {
      isDisplayingDetail.value = false;
    }
    setState(() {});
  }

  void onResult(List<AssetEntity>? result) {
    if (result != null && result != selectedAssets) {
      selectedAssets = result.toList();
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: <Widget>[
        Expanded(
          child: ActualAssetPickerWidget(
            pickMethod: getPickMethod(context),
            onMethodSelected: selectAssets,
            child: userSuppliedWidget,
          ),
        ),
        if (selectedAssets.isNotEmpty)
          SelectedAssetsListView(
            assets: selectedAssets,
            isDisplayingDetail: isDisplayingDetail,
            onResult: onResult,
            onRemoveAsset: removeAsset,
          ),
      ],
    );
  }
}
