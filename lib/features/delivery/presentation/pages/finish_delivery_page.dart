// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gas/core/config/theme/colors.dart';
import 'package:gas/core/utils/common.dart';
import 'package:iconsax/iconsax.dart';

class FinishDeliveryPage extends StatefulWidget {
  const FinishDeliveryPage({super.key});

  @override
  State<FinishDeliveryPage> createState() => _FinishDeliveryPageState();
}

class _FinishDeliveryPageState extends State<FinishDeliveryPage> {
  File? imageFile;
  late CameraController _controller;
  bool _isCameraInitialized = false;
  bool _isFlashOn = false;
  List<CameraDescription> _cameras = [];
  int _selectedCameraIndex = 0;
  bool _showCamera = true;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(
      _cameras[_selectedCameraIndex],
      ResolutionPreset.medium,
    );
    await _controller.initialize();
    _isCameraInitialized = true;
    if (mounted) setState(() {});
  }

  Future<void> _toggleFlash() async {
    if (!_isCameraInitialized) return;

    try {
      _isFlashOn = !_isFlashOn;
      await _controller.setFlashMode(
        _isFlashOn ? FlashMode.torch : FlashMode.off,
      );
      setState(() {});
    } catch (e) {
      debugPrint("Flash toggle error: $e");
      showSnack(text: "Error toggling flash", backgroundColor: Colors.red);
    }
  }

  Future<void> _switchCamera() async {
    if (_cameras.length < 2) return;

    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;
    _controller = CameraController(
      _cameras[_selectedCameraIndex],
      ResolutionPreset.medium,
    );
    await _controller.initialize();
    if (_isFlashOn) {
      await _controller.setFlashMode(FlashMode.torch);
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(
            context: context,
            onBackTap: () => Navigator.pop(context),
            onMenuTap: () {
              showSnack(text: "Image saved to the gallery");
            },
            title: "Finish Delivery",
          ),
          _camera(),
          SliverToBoxAdapter(child: SizedBox(height: 20.h)),
          _heading(
            context: context,
            title: "Delivery Details",
            subtitle: "Open QR Code",
            onTap: () {},
          ),
          SliverToBoxAdapter(child: SizedBox(height: 10.h)),
          _fields(),
          SliverToBoxAdapter(child: SizedBox(height: 20.h)),
        ],
      ),
    );
  }

  SliverToBoxAdapter _fields() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          CommonTextFormField(
            margin: EdgeInsets.symmetric(horizontal: 15.w),
            labelText: "Consumer Number",
            hintText: "e.g. Xyz Kumar",
            controller: TextEditingController(text: "1234567890"),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: CommonTextFormField(
                  margin: EdgeInsets.only(left: 15.w, right: 10.w),
                  labelText: "Payment Method",
                  hintText: "e.g. Cash",
                  controller: TextEditingController(text: "Cash"),
                ),
              ),
              Expanded(
                child: CommonTextFormField(
                  margin: EdgeInsets.only(right: 15.w),
                  labelText: "Money Paid",
                  hintText: "e.g. 100",
                  controller: TextEditingController(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _heading({
    required BuildContext context,
    required String title,
    required String subtitle,
    required void Function() onTap,
  }) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: onTap,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 7.w,
                      vertical: 7.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.blue600,
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: Icon(Iconsax.scan, color: Colors.white, size: 15.r),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _camera() {
    return SliverToBoxAdapter(
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            height: 400.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              color: Colors.black,
            ),
            child: _showCamera && _isCameraInitialized
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(15.r),
                    child: CameraPreview(_controller),
                  )
                : imageFile != null && !_showCamera
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(15.r),
                    child: Image.file(
                      imageFile!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error);
                      },
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          if (_showCamera) ...[
            Positioned(
              top: 30.h,
              right: 30.w,
              child: Row(
                children: [
                  _circularBlurIcon(
                    icon: _isFlashOn ? Iconsax.flash_1 : Iconsax.flash_slash,
                    onTap: _toggleFlash,
                  ),
                  SizedBox(width: 20.w),
                  _circularBlurIcon(icon: Iconsax.repeat, onTap: _switchCamera),
                ],
              ),
            ),
          ],
          Positioned(
            bottom: 30.h,
            right: 30.w,
            child: GestureDetector(
              onTap: !_showCamera && imageFile != null
                  ? () {
                      setState(() {
                        imageFile = null;
                        _showCamera = true;
                      });
                    }
                  : _capture,
              child: Center(
                child: ClipOval(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      height: 80.h,
                      width: 80.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.2),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: !_showCamera && imageFile != null
                          ? Icon(
                              Iconsax.refresh,
                              color: Colors.white,
                              size: 30.r,
                            )
                          : null,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20.h,
            left: 30.w,
            child: _deliveryTile(
              context: context,
              image:
                  "https://images.unsplash.com/photo-1529258297641-785a413968af?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTJ8fGRwfGVufDB8fDB8fHww",
              title: "Mark Snowman",
              subtitle: "12 May, 12:45 PM",
            ),
          ),
        ],
      ),
    );
  }

  Padding _deliveryTile({
    required BuildContext context,
    required String image,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipOval(
            child: Image.network(
              height: 50.r,
              width: 50.r,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error);
              },
              image,
            ),
          ),
          SizedBox(width: 15.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                subtitle,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _circularBlurIcon({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 40.r,
            width: 40.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.2),
              border: Border.all(color: Colors.white, width: 1.5),
            ),
            child: Icon(icon, color: Colors.white, size: 20.r),
          ),
        ),
      ),
    );
  }

  void _capture() async {
    try {
      if (!_isCameraInitialized) return;

      final XFile picture = await _controller.takePicture();
      final File file = File(picture.path);
      setState(() {
        imageFile = file;
        _showCamera = false;
      });

      // openBottomSheet(
      //   context: context,
      //   minChildSize: 0.9,
      //   initialChildSize: 0.9,
      //   child: FinishDeliveryWidget(
      //     imageFile: imageFile,
      //     picture: picture,
      //     context: context,
      //   ),
      // );
    } catch (e) {
      debugPrint('Error capturing image: $e');
      showSnack(text: "Error capturing image", backgroundColor: Colors.red);
    }
  }

  Widget _buildSliverAppBar({
    required BuildContext context,
    required void Function() onBackTap,
    required void Function() onMenuTap,
    required String title,
  }) {
    return SliverAppBar(
      leading: IconButton(
        onPressed: onBackTap,
        icon: const Icon(Iconsax.arrow_left),
      ),
      pinned: true,
      actions: [
        TextButton(
          onPressed: () {},
          child: const Text(
            "Save",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
      title: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
    );
  }
}
