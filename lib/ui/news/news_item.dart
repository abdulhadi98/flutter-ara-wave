import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wave_flutter/helper/app_colors.dart';
import 'package:wave_flutter/helper/app_fonts.dart';
import 'package:wave_flutter/helper/utils.dart';
import 'package:wave_flutter/models/news_model.dart';
import 'package:wave_flutter/ui/common_widgets/base_statefull_widget.dart';

class NewsItem extends BaseStateFullWidget {
  final NewsModel newsItem;
  NewsItem({required this.newsItem});

  @override
  _NewsItemState createState() => _NewsItemState();
}

class _NewsItemState extends BaseStateFullWidgetState<NewsItem> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () => Utils.launchURL(widget.newsItem.url),
      child: Container(
        // height: height* .1,
        padding: EdgeInsets.symmetric(
            horizontal: width * .04, vertical: height * .035),
        decoration: BoxDecoration(
          color: AppColors.mainColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: IntrinsicHeight(
          child: Row(
            //    mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.newsItem.title,
                      style: TextStyle(
                        fontSize: AppFonts.getMediumFontSize(context),
                        color: AppColors.white,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: height * .02),
                    Text(
                      widget.newsItem.description,
                      style: TextStyle(
                        fontSize: AppFonts.getSmallFontSize(context),
                        color: AppColors.white,
                        height: 1.2,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // SizedBox(height: height* .01),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.newsItem.createdAt == ''
                                ? ''
                                : widget.newsItem.createdAt.substring(
                                    0, widget.newsItem.createdAt.length - 13),
                            style: TextStyle(
                              fontSize: AppFonts.getXSmallFontSize(context),
                              color: AppColors.white,
                              height: 1.0,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            widget.newsItem.author,
                            style: TextStyle(
                              fontSize: AppFonts.getXSmallFontSize(context),
                              color: AppColors.white,
                              height: 1.0,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(width: width * .04),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Utils.buildImage(
                    url: widget.newsItem.enclosure?.url ?? '',
                    width: width * .3,
                    height: width * .32,
                    fit: BoxFit.cover),
              )
            ],
          ),
        ),
      ),
    );
  }
}
