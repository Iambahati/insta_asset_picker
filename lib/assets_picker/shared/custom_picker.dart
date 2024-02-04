
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

Future<AssetEntity?> _pickFromCamera(BuildContext c) {
  return CameraPicker.pickFromCamera(
    c,
    pickerConfig: const CameraPickerConfig(enableRecording: false, textDelegate: EnglishCameraPickerTextDelegate(),),
  );
}

/// A class representing a method for picking assets.
class PickMethod {
  /// The core function that defines how to use the picker.
  final Future<List<AssetEntity>?> Function(
    BuildContext context,
    List<AssetEntity> selectedAssets,
  ) method;

  /// Constructs a [PickMethod] with the given method.
  const PickMethod({
    required this.method,
  });

  /// Constructs a custom [PickMethod] with the specified maximum assets count.
  factory PickMethod.custom(BuildContext context, int maxAssetsCount) {
    return PickMethod(
      method: (BuildContext context, List<AssetEntity> assets) {
        const AssetPickerTextDelegate textDelegate = AssetPickerTextDelegate();
        return AssetPicker.pickAssets(
          context,
          pickerConfig: AssetPickerConfig(
            maxAssets: maxAssetsCount,
            requestType: RequestType.image,
            selectedAssets: assets,
            specialItemPosition: SpecialItemPosition.prepend,
            // specialPickerType: SpecialPickerType.noPreview,
            specialItemBuilder: (
              BuildContext context,
              AssetPathEntity? path,
              int length,
            ) {
              if (path?.isAll != true) {
                return null;
              }
              return Semantics(
                label: textDelegate.sActionUseCameraHint,
                button: true,
                onTapHint: textDelegate.sActionUseCameraHint,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  /// Handles the tap event by picking an asset from the camera.
                  ///
                  /// This method is triggered when the user taps on a specific widget.
                  /// It calls the `_pickFromCamera` method to capture an asset from the camera.
                  /// If the result is null, the method returns early.
                  /// If the widget is still mounted, it retrieves the ancestor widget of type `AssetPicker`.
                  /// It then obtains the `DefaultAssetPickerBuilderDelegate` and `DefaultAssetPickerProvider` from the builder.
                  /// The method switches the current path to a new path obtained from the provider.
                  /// Finally, it selects the captured asset using the `selectAsset` method of the provider.
                  ///
                  onTap: () async {
                    final AssetEntity? result = await _pickFromCamera(context);
                    if (result == null) {
                      return;
                    }

                      // final AssetPicker<AssetEntity, AssetPathEntity> picker =
                      //     context.findAncestorWidgetOfExactType()!;
                      // final DefaultAssetPickerBuilderDelegate builder =
                      //     picker.builder as DefaultAssetPickerBuilderDelegate;
                      // final DefaultAssetPickerProvider p = builder.provider;
                      // await p.switchPath(
                      //   PathWrapper<AssetPathEntity>(
                      //     path:
                      //         await p.currentPath!.path.obtainForNewProperties(),
                      //   ),
                      // );
                      // p.selectAsset(result);
                    if (context.mounted) {
                      final AssetPicker<AssetEntity, AssetPathEntity> picker =
                          context.findAncestorWidgetOfExactType()!;
                      final DefaultAssetPickerBuilderDelegate builder =
                          picker.builder as DefaultAssetPickerBuilderDelegate;
                      final DefaultAssetPickerProvider p = builder.provider;
                      await p.switchPath(
                        PathWrapper<AssetPathEntity>(
                          path:
                              await p.currentPath!.path.obtainForNewProperties(),
                        ),
                      );
                      p.selectAsset(result);
                    }
                  },
                  child: const Center(
                    child: Icon(Icons.photo_camera, size: 42.0),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
  
}