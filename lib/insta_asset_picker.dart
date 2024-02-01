import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

class InstaAssetPicker extends StatefulWidget {
  const InstaAssetPicker({super.key});

  @override
  State<InstaAssetPicker> createState() => _InstaAssetPickerState();
}

class _InstaAssetPickerState extends State<InstaAssetPicker> {
  AssetEntity? selectedEntity;
  AssetPathEntity? selectedAlbum;
  List<AssetPathEntity> albumList = [];
  List<AssetEntity> assetList = [];
  List<AssetEntity> selectedAssetList = [];

  bool isMultiPickMode = false;

  Future<List<AssetPathEntity>> loadAlbums() async {
    var permissionStatus = await PhotoManager.requestPermissionExtend();

    List<AssetPathEntity> albums = [];

    if (permissionStatus.isAuth) {
      albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        hasAll: true,
        filterOption: FilterOptionGroup()
          ..setOption(
            AssetType.image,
            const FilterOption(
              sizeConstraint: SizeConstraint(ignoreSize: true),
            ),
          ),
      );
    } else {
      PhotoManager.openSetting();
    }

    return albums;
  }

  Future loadAssets(AssetPathEntity selectedAlbum) async {
    List<AssetEntity> assets = await selectedAlbum.getAssetListRange(
      start: 0,
      end: await selectedAlbum.assetCountAsync,
    );
    return assets;
  }

  @override
  void initState() {
    super.initState();

    loadAlbums().then((value) {
      setState(() {
        albumList = value;
        selectedAlbum = value[0];
      });
      
      loadAssets(selectedAlbum!).then((value) {
        setState(() {
          assetList = value;
          selectedEntity = value[0];
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var ht = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.black,
          leading: const CloseButton(
            color: Colors.white,
          ),
          centerTitle: true,
          title: const Text("Instagram's Media Picker"),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.arrow_forward,
                color: Colors.blueAccent,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            SizedBox(
              height: ht * 0.5,
              child: selectedEntity == null
                  ? const SizedBox.shrink()
                  : Stack(
                      children: [
                        Positioned.fill(
                          child: AssetEntityImage(
                            selectedEntity!,
                            isOriginal: false,
                            thumbnailSize: const ThumbnailSize.square(1000),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            ),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 5,
                    ),
                    child: Row(
                      children: [
                        if (selectedAlbum != null)
                          GestureDetector(
                            onTap: () {
                              albums(ht);
                            },
                            child: Text(
                              selectedAlbum!.name == "Recent"
                                  ? "Gallery"
                                  : selectedAlbum!.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        const Padding(
                          padding: EdgeInsets.only(
                            left: 10,
                          ),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              isMultiPickMode =
                                  isMultiPickMode == true ? false : true;
                              selectedAssetList = [];
                            });
                          },
                          icon: Icon(
                            isMultiPickMode == true
                                ? Icons.done_all_rounded
                                : Icons.remove_done,
                            color: Colors.white,
                            size: 30,
                          ),
                        )
                      ],
                    ),
                  ),
                  Flexible(
                    child: assetList.isEmpty
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: assetList.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: 1,
                              crossAxisSpacing: 1,
                            ),
                            itemBuilder: (context, index) {
                              AssetEntity assetEntity = assetList[index];
                              return assetWidget(assetEntity);
                            },
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void albums(height) {
    showModalBottomSheet(
      backgroundColor: const Color(0xff101010),
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      builder: (context) {
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: albumList.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                setState(() {
                  selectedAlbum = albumList[index];
                });
                loadAssets(selectedAlbum!).then(
                  (value) {
                    setState(() {
                      assetList = value;
                      selectedEntity = assetList[0];
                    });
                  },
                );
                Navigator.pop(context);
              },
              title: Text(
                albumList[index].name == "Recent"
                    ? "Gallery"
                    : albumList[index].name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            );
          },
        );
      },
    );
  }

  void selectAsset({
    required AssetEntity assetEntity,
  }) {
    if (selectedAssetList.contains(assetEntity)) {
      setState(() {
        selectedAssetList.remove(assetEntity);
      });
    } else {
      setState(() {
        selectedAssetList.add(assetEntity);
      });
    }
  }

  Widget assetWidget(AssetEntity assetEntity) => GestureDetector(
        onTap: () {
          setState(() {
            selectedEntity = assetEntity;
          });
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: AssetEntityImage(
                assetEntity,
                isOriginal: false,
                thumbnailSize: const ThumbnailSize.square(250),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                  );
                },
              ),
            ),
            Positioned.fill(
              child: Container(
                color: assetEntity == selectedEntity
                    ? Colors.white60
                    : Colors.transparent,
              ),
            ),
            if (isMultiPickMode == true)
              Positioned.fill(
                child: Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      selectAsset(assetEntity: assetEntity);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Container(
                        decoration: BoxDecoration(
                          color: selectedAssetList.contains(assetEntity) == true
                              ? Colors.blue
                              : Colors.white12,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 1.5,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            "${selectedAssetList.indexOf(assetEntity) + 1}",
                            style: TextStyle(
                              color: selectedAssetList.contains(assetEntity) ==
                                      true
                                  ? Colors.white
                                  : Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
}
