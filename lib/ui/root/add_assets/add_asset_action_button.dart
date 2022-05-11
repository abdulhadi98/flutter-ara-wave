import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wave_flutter/helper/app_colors.dart';
import 'package:wave_flutter/helper/app_fonts.dart';
import 'package:wave_flutter/ui/common_widgets/base_statefull_widget.dart';
import 'package:wave_flutter/ui/common_widgets/image_widget.dart';
import 'package:wave_flutter/ui/root/add_assets/loading_indicator.dart';

class AddAssetActionButton extends BaseStateFullWidget {
  final VoidCallback onClicked;
  final ValueStream<bool>? validationStream;
  final ValueStream<bool>? loadingStream;
  final String titleKey;
  final String? iconUrl;

  AddAssetActionButton({
    required this.onClicked,
    required this.titleKey,
    this.validationStream,
    this.loadingStream,
    this.iconUrl,
  });

  @override
  createState() => _AddAssetActionButtonState();
}

class _AddAssetActionButtonState extends BaseStateFullWidgetState<AddAssetActionButton> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      initialData: false,
      stream: widget.loadingStream,
      builder: (context, loadingSnapshot) {
        if(loadingSnapshot.data??false) return LoadingIndicator();
        else return buildButtonWidget();
      },
    );
  }

  Widget buildButtonWidget() {
    return StreamBuilder<bool>(
        initialData: false,
        stream: widget.validationStream,
        builder: (context, validationSnapshot) {
          bool isValid = validationSnapshot.data!;
          return GestureDetector(
            onTap: !isValid ? null : widget.onClicked,
            child: Container(
              height: height* .06,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.mainColor,
                border: Border.all(color: isValid ? Colors.white : AppColors.mainColor, width: .5),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      appLocal.trans(widget.titleKey),
                      style: TextStyle(
                        color: isValid ? Colors.white : Colors.white.withOpacity(.25),
                        fontSize: AppFonts.getNormalFontSize(context),
                        height: 1.0,
                      ),
                    ),
                  ),
                  if(widget.iconUrl!=null) Positioned(
                    top: 0.0,
                    right: 48.0,
                    bottom: 0.0,
                    child: ImageWidget(
                      url: widget.iconUrl!,
                      width: width* .029,
                      height: width* .029,
                      fit: BoxFit.contain,
                      color: isValid ? Colors.white : Colors.white.withOpacity(.25),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}
