// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gas/core/config/theme/colors.dart';
import 'package:gas/core/utils/common.dart';
import 'package:gas/core/utils/location.dart';
import 'package:gas/features/delivery/data/models/delivery_model.dart';
import 'package:gas/features/delivery/presentation/cubit/delivery_cubit.dart';
import 'package:gas/features/home/presentation/cubit/home_cubit.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class FinishDeliveryPage extends StatefulWidget {
  final DeliveryModel delivery;
  const FinishDeliveryPage({super.key, required this.delivery});

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

  TextEditingController consumerNoController = TextEditingController();
  TextEditingController paymentMethodController = TextEditingController();
  TextEditingController moneyPaidController = TextEditingController();

  List<String> paymentMethods = ["Cash", "UPI"];

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
    return BlocConsumer<DeliveryCubit, DeliveryState>(
      listener: (context, state) {},
      builder: (context, state) {
        final delivery = state.deliveries.firstWhere(
          (delivery) => delivery.id == widget.delivery.id,
          orElse: () => widget.delivery,
        );
        final consumer = state.consumers.firstWhere(
          (consumer) => consumer.id == delivery.consumerID,
        );

        consumerNoController.text = consumer.consumerNo;
        moneyPaidController.text = delivery.fees.toString();

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              _buildSliverAppBar(
                context: context,
                onBackTap: () => Navigator.pop(context),
                onSaveTap: () async => await _finishDelivery(context, delivery),
                title: "Finish Delivery",
              ),
              _camera(
                consumerImage: consumer.image,
                consumerName: consumer.name,
              ),
              SliverToBoxAdapter(child: SizedBox(height: 20.h)),
              _heading(
                context: context,
                title: "Delivery Details",
                subtitle: "Open QR Code",
                onTap: () async {},
              ),
              SliverToBoxAdapter(child: SizedBox(height: 10.h)),
              _fields(
                consumerNoController: consumerNoController,
                paymentMethodController: paymentMethodController,
                moneyPaidController: moneyPaidController,
              ),
              SliverToBoxAdapter(child: SizedBox(height: 20.h)),
            ],
          ),
        );
      },
    );
  }

  Future<void> _finishDelivery(
    BuildContext context,
    DeliveryModel delivery,
  ) async {
    showSnack(
      text: "Finishing Delivery...",
      backgroundColor: AppColors.blue500,
      sticky: true,
    );
    final td = Timestamp.now();
    final lastLocation =
        context.read<HomeCubit>().state.lastLocation.isNotEmpty == true
        ? context.read<HomeCubit>().state.lastLocation.first
        : UserLocationModel();

    final result = await context.read<DeliveryCubit>().updateDelivery(
      delivery: delivery.copyWith(
        employeeID: FirebaseAuth.instance.currentUser?.uid ?? "",
        deliveryLocation: lastLocation,
        paid: num.parse(moneyPaidController.text),
        paymentMethod: paymentMethodController.text,
        deliveryTD: td,
        status: "completed",
      ),
      image: imageFile,
    );

    if (result) {
      Navigator.of(context).pop();
      showSnack(
        text: "Delivery Finished Successfully",
        backgroundColor: AppColors.green500,
      );
    } else {
      showSnack(
        text: "Failed to finish delivery",
        backgroundColor: AppColors.red500,
      );
    }
  }

  SliverToBoxAdapter _fields({
    required TextEditingController consumerNoController,
    required TextEditingController paymentMethodController,
    required TextEditingController moneyPaidController,
  }) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          CommonTextFormField(
            margin: EdgeInsets.symmetric(horizontal: 15.w),
            labelText: "Consumer Number",
            hintText: "e.g. Xyz Kumar",
            controller: consumerNoController,
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: CommonTextFormField(
                  margin: EdgeInsets.only(left: 15.w, right: 10.w),
                  labelText: "Payment Method",
                  hintText: "e.g. Cash",
                  suffixIcon: Iconsax.arrow_down_1,
                  controller: paymentMethodController,
                  onTap: () async {
                    final paymentMethod = await openBottomSheet<String?>(
                      child: Column(
                        children: paymentMethods
                            .map(
                              (e) => InkWell(
                                onTap: () {
                                  Navigator.pop(context, e);
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 15.h,
                                  ),
                                  child: Text(
                                    e,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    );
                    if (paymentMethod != null) {
                      setState(() {
                        paymentMethodController.text = paymentMethod;
                      });
                    }
                  },
                ),
              ),
              Expanded(
                child: CommonTextFormField(
                  margin: EdgeInsets.only(right: 15.w),
                  labelText: "Money Paid",
                  hintText: "e.g. 100",
                  controller: moneyPaidController,
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

  SliverToBoxAdapter _camera({
    required String consumerImage,
    required String consumerName,
  }) {
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
              image: consumerImage,
              title: consumerName,
              subtitle: DateFormat("dd MMM, hh:mm a").format(DateTime.now()),
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
    required void Function() onSaveTap,
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
          onPressed: onSaveTap,
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
