import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

class TransparentAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TransparentAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
            systemNavigationBarIconBrightness:
                Theme.of(context).brightness == Brightness.dark
                    ? Brightness.light
                    : Brightness.dark,
            statusBarColor: Colors.transparent,
            statusBarIconBrightness:
                Theme.of(context).brightness == Brightness.dark
                    ? Brightness.light
                    : Brightness.dark));
  }

  @override
  Size get preferredSize => const Size(double.infinity, 0);
}

class CommonTextField extends StatelessWidget {
  final String? labelText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function()? onTap;
  final bool? readOnly;
  const CommonTextField({
    super.key,
    this.labelText,
    this.controller,
    this.keyboardType,
    this.validator,
    this.onTap,
    this.readOnly,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: Colors.black,
      maxLines: null,
      keyboardType: keyboardType,
      validator: validator,
      onTap: onTap,
      readOnly: readOnly ?? false,
      style: TextStyle(
          color: Theme.of(context).iconTheme.color,
          fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey, width: 1)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                BorderSide(color: Theme.of(context).primaryColor, width: 2)),
      ),
    );
  }
}

class CommonFloatingActionButton extends StatelessWidget {
  final void Function() onPressed;
  final IconData icon;
  const CommonFloatingActionButton(
      {super.key, required this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      child: FloatingActionButton(
          onPressed: onPressed,
          shape: const CircleBorder(),
          foregroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor.withOpacity(1),
          child: Icon(icon, color: Colors.white)),
    );
  }
}

class ProfileImagePicker extends StatelessWidget {
  final File? profileImage;
  final String? networkImage;
  final Function(File) onImageSelected;

  const ProfileImagePicker({
    super.key,
    this.profileImage,
    required this.onImageSelected,
    this.networkImage,
  });

  Future<void> pickAndCompressImage({
    required BuildContext context,
    required Function(File) onImageSelected,
    required ImageSource source,
  }) async {
    final picker = ImagePicker();
    final XFile? xfile = await picker.pickImage(source: source);

    if (xfile != null) {
      final compressedImage = await FlutterImageCompress.compressAndGetFile(
        xfile.path,
        "${xfile.path}_compressed.jpg",
        quality: 60,
      );

      if (compressedImage != null) {
        onImageSelected(File(compressedImage.path));
      }
    }
  }

  Future<void> showImageSourceSelectionDialog({
    required BuildContext context,
    required Function(File) onImageSelected,
  }) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text('Select Image Source',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (networkImage != null || profileImage != null) ...[
              ListTile(
                leading: const Icon(Iconsax.eye),
                title: Text('See the image',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold)),
                onTap: () async {
                  Navigator.pop(context); // Close the dialog
                  if (networkImage != null || profileImage != null) {
                    await openPopUp(
                        context: context,
                        networkImage: networkImage,
                        profileImage: profileImage);
                  }
                },
              ),
            ],
            ListTile(
              leading: const Icon(Iconsax.camera),
              title: Text('Take a Photo',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold)),
              onTap: () async {
                Navigator.pop(context); // Close the dialog
                await pickAndCompressImage(
                  context: context,
                  onImageSelected: onImageSelected,
                  source: ImageSource.camera,
                );
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.gallery),
              title: Text('Choose from Gallery',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold)),
              onTap: () async {
                Navigator.pop(context); // Close the dialog
                await pickAndCompressImage(
                  context: context,
                  onImageSelected: onImageSelected,
                  source: ImageSource.gallery,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () async {
          showImageSourceSelectionDialog(
            context: context,
            onImageSelected: onImageSelected,
          );
        },
        onLongPress: () {
          if (networkImage != null || profileImage != null) {
            openPopUp(
                context: context,
                networkImage: networkImage,
                profileImage: profileImage);
          }
        },
        child: ClipOval(
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (networkImage != null) ...[
                CachedNetworkImage(
                  imageUrl: networkImage!,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ],
              if (profileImage != null) ...[
                Image.file(
                  profileImage!,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ],
              Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  shape: BoxShape.circle,
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(75),
                      bottomRight: Radius.circular(75),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black
                              .withOpacity(0.4), // Slightly increased opacity
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(75),
                            bottomRight: Radius.circular(75),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Upload\nImage',
                            textAlign: TextAlign.center,
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
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
        ),
      ),
    );
  }
}

Future<void> openPopUp({
  required BuildContext context,
  required String? networkImage,
  required File? profileImage,
}) async {
  showDialog(
    context: context,
    barrierColor: Colors.transparent,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        child: Stack(
          children: [
            // Blur background
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(
                  // color: Colors.black.withOpacity(0.2),
                  ),
            ),
            // Circular image
            if (networkImage != null) ...[
              Center(
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: networkImage,
                    placeholder: (context, url) => CircularProgressIndicator(
                      strokeWidth: 1,
                      color: Colors.black.withOpacity(.1),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ] else if (profileImage != null) ...[
              Center(
                child: ClipOval(
                  child: Image.file(
                    profileImage,
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    },
  );
}
