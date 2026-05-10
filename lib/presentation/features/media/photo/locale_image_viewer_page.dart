import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:koreaislam/core/gen/assets/assets.gen.dart';
import 'package:koreaislam/data/datasource/network/constants/constants.dart';
import 'package:koreaislam/domain/models/media/media_file.dart';
import 'package:koreaislam/presentation/support/extensions/color_extension.dart';
import 'package:koreaislam/presentation/support/extensions/platform_sizes.dart';
import 'package:koreaislam/presentation/support/extensions/xfile_exts.dart';
import 'package:koreaislam/presentation/widgets/material/material_elevated_button.dart';

@RoutePage()
class LocaleImageViewerPage extends StatefulWidget {
  final List<MediaFile> images;
  final int initialIndex;
  final bool isLocalPhotos;

  const LocaleImageViewerPage({
    super.key,
    required this.images,
    required this.initialIndex,
    this.isLocalPhotos = false,
  });

  @override
  _LocaleImageViewerPageState createState() => _LocaleImageViewerPageState();
}

class _LocaleImageViewerPageState extends State<LocaleImageViewerPage> {
  late int currentIndex;
  List<MediaFile> images = [];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    images.addAll(widget.images.map((e) => e.copy()).toList());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ));
    });
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height;
    height = MediaQuery.of(context).size.height;

    var pageController = PageController(initialPage: currentIndex);

    return WillPopScope(
      onWillPop: () async {
        context.router.pop(images);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: PopScope(
          onPopInvoked: (didPop) {
            // if (didPop) {
            //   // context.router.pop(images);
            //   AutoRouter.of(context).pop(images);
            // }
          },
          child: Stack(
            children: [
              _buildImageList(pageController, height),
              _buildBackButton(context),
              _buildActionButtons(context, pageController),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewBody(BuildContext context) {
    return PhotoViewGallery.builder(
      reverse: false,
      onPageChanged: onPageChanged,
      pageController: PageController(initialPage: currentIndex),
      scrollPhysics: const BouncingScrollPhysics(),
      builder: (BuildContext context, int index) {
        final imageUrl = widget.images[index].uploadedFileUrl!;
        var actualUrl =
            imageUrl.contains("https://") || imageUrl.contains("http://")
                ? imageUrl
                : "${Constants.baseUrlForImage}$imageUrl";
        return PhotoViewGalleryPageOptions(
          imageProvider: NetworkImage(actualUrl),
          initialScale: PhotoViewComputedScale.contained * 1,
          heroAttributes: PhotoViewHeroAttributes(
            tag: widget.images[index],
          ),
        );
      },
      itemCount: widget.images.length,
      loadingBuilder: (context, event) => Center(
        child: SizedBox(
          width: double.infinity,
          // height: height / 2,
          child: Center(child: CircularProgressIndicator(color: context.colorAccent)),
        ),
      ),
    );
  }

  PhotoViewGallery _buildImageList(
    PageController pageController,
    double height,
  ) {
    return PhotoViewGallery.builder(
      reverse: false,
      onPageChanged: onPageChanged,
      pageController: pageController,
      scrollPhysics: const BouncingScrollPhysics(),
      builder: (BuildContext context, int index) {
        ImageProvider imageProvider;
        if (images[index].isUploaded()) {
          imageProvider = NetworkImage(images[index].uploadedFileUrl!);
        } else {
          imageProvider = images[index].localMediaFile!.toFileImage();
        }

        return PhotoViewGalleryPageOptions(
          imageProvider: imageProvider,
          initialScale: PhotoViewComputedScale.contained * 1,
          heroAttributes: PhotoViewHeroAttributes(tag: images[index]),
        );
      },
      itemCount: images.length,
      loadingBuilder: (context, event) => Center(
        child: SizedBox(
          width: double.infinity,
          height: height / 2,
          child: Center(child: CircularProgressIndicator(color: context.colorAccent)),
        ),
      ),
    );
  }

  Positioned _buildBackButton(BuildContext context) {
    return Positioned(
      top: 48,
      left: 12,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.all(Radius.circular(12)),
        child: Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () {
              context.router.pop(images);
            },
            icon: Assets.images.appBar.localeImageViewerActionBack
                .svg(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Positioned _buildActionButtons(
    BuildContext context,
    PageController pageController,
  ) {
    return Positioned(
      left: 16,
      bottom: defaultBottomPadding,
      right: 16,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: MaterialElevatedButton(
              height: 32,
              text: (currentIndex == 0
                  ? "Strings.commonMainPhoto"
                  : "Strings.commonMakeMainPhoto"),
              enabled: currentIndex != 0,
              onPressed: () {
                var item = images.removeAt(currentIndex);
                images.insert(0, item);
                setState(() {
                  images = images;
                });
                // if (pageController.hasClients) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  pageController.jumpToPage(0);
                });
              },
              textColor: Colors.black,
              backgroundColor: context.backgroundGreyColor,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: MaterialElevatedButton(
              height: 32,
              text: "Strings.commonDelete",
              onPressed: () {
                setState(() {
                  images.removeAt(currentIndex);
                  if (images.isEmpty) {
                    context.router.pop(images);
                  }
                });
              },
              textColor: Colors.black,
              backgroundColor: context.backgroundGreyColor,
            ),
          )
        ],
      ),
    );
  }
}
