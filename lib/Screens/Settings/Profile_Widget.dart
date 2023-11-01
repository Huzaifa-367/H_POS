import 'package:flutter/material.dart';
import 'package:mobile_pos/constant.dart';

class BigUserCard extends StatelessWidget {
  Color? backgroundColor;
  Color? settingColor;
  double? cardRadius;
  Color? backgroundMotifColor;
  Widget? cardActionWidget;
  String? userName;
  Widget? role;
  Widget? userMoreInfo;
  ImageProvider? userProfilePic;
  List<Widget>? popupWidget;

  BigUserCard({
    Key? key,
    this.backgroundColor,
    this.settingColor,
    this.cardRadius = 30,
    required this.userName,
    this.role,
    this.backgroundMotifColor = Colors.white,
    this.cardActionWidget,
    this.userMoreInfo,
    this.popupWidget,
    required this.userProfilePic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQueryHeight = MediaQuery.of(context).size.height;
    userMoreInfo ??= Container();
    return Container(
      height: mediaQueryHeight / 3.5,
      margin: const EdgeInsets.only(bottom: 30),
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).cardColor,
        borderRadius:
            BorderRadius.circular(double.parse(cardRadius!.toString())),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: CircleAvatar(
              radius: 100,
              backgroundColor: backgroundMotifColor!.withOpacity(.1),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: CircleAvatar(
              radius: 400,
              backgroundColor: backgroundMotifColor!.withOpacity(.05),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: (cardActionWidget != null)
                  ? MainAxisAlignment.spaceEvenly
                  : MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // User profile
                    Expanded(
                      child: GestureDetector(
                        child: CircleAvatar(
                          radius: mediaQueryHeight / 15,
                          backgroundImage: userProfilePic!,
                        ),
                        onTap: () {
                          //Dialog
                          showDialog(
                            //useSafeArea: true,
                            //To disable alert background
                            barrierDismissible: false,
                            context: context,
                            builder: (context) => AlertDialog(
                              //title: const Text("Alert Dialog Box"),
                              //content: const Text("Do you want to login?"),
                              actions: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: (() {
                                        Navigator.of(context).pop();
                                      }),
                                      icon: const Icon(Icons.cancel_outlined),
                                    ),
                                  ],
                                ),
                                Container(
                                  child: Image(
                                    image: userProfilePic!,
                                  ),
                                ),
                                ...(popupWidget ?? []),
                              ],
                            ),
                          );

                          //
                        },
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            userName!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                          userMoreInfo!,
                          role!,
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: settingColor ?? Theme.of(context).cardColor,
                  ),
                  child: (cardActionWidget != null)
                      ? cardActionWidget
                      : Container(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//
//
//
//
//
//
//
//
//
//
//
//

class SettingsScreenUtils {
  static double? settingsGroupIconSize;
  static TextStyle? settingsGroupTitleStyle;
}

class IconStyle {
  Color? iconsColor;
  bool? withBackground;
  Color? backgroundColor;
  double? borderRadius;

  IconStyle({
    iconsColor = Colors.white,
    withBackground = true,
    backgroundColor = Colors.blue,
    borderRadius = 8,
  })  : iconsColor = iconsColor,
        withBackground = withBackground,
        backgroundColor = backgroundColor,
        borderRadius = double.parse(borderRadius!.toString());
}

/// This component group the Settings items (BabsComponentSettingsItem)
/// All one BabsComponentSettingsGroup have a title and the developper can improve the design.

class SettingsGroup extends StatelessWidget {
  final String? settingsGroupTitle;
  final TextStyle? settingsGroupTitleStyle;
  final List<Widget> items;
  final double iconItemSize;

  const SettingsGroup({
    Key? key,
    this.settingsGroupTitle,
    this.settingsGroupTitleStyle,
    required this.items,
    this.iconItemSize = 25,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SettingsScreenUtils.settingsGroupIconSize = iconItemSize;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // The title
          if (settingsGroupTitle != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(
                settingsGroupTitle!,
                style: settingsGroupTitleStyle ??
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
          // The SettingsGroup sections
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListView.builder(
              //separatorBuilder: (context, index) => const Divider(),
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) => Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: items[index],
              ),
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const ScrollPhysics(),
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsItem extends StatelessWidget {
  final IconData icon;
  final IconStyle? iconStyle;
  final String title;
  final TextStyle? titleStyle;
  final String? subtitle;
  final TextStyle? subtitleStyle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? backgroundColor;

  const SettingsItem({
    Key? key,
    required this.icon,
    this.iconStyle,
    required this.title,
    this.titleStyle,
    this.subtitle = "",
    this.subtitleStyle,
    this.backgroundColor,
    this.trailing,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        color: Constants().kBgColor,
        child: ListTile(
          onTap: onTap,
          leading: (iconStyle != null && iconStyle!.withBackground!)
              ? Container(
                  decoration: BoxDecoration(
                    color: iconStyle!.backgroundColor,
                    borderRadius:
                        BorderRadius.circular(iconStyle!.borderRadius!),
                  ),
                  padding: const EdgeInsets.all(4.5),
                  child: Icon(
                    icon,
                    size: SettingsScreenUtils.settingsGroupIconSize,
                    color: iconStyle!.iconsColor,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(4.5),
                  child: Icon(
                    icon,
                    size: SettingsScreenUtils.settingsGroupIconSize,
                  ),
                ),
          title: Text(
            title,
            style: titleStyle ?? const TextStyle(fontWeight: FontWeight.bold),
            maxLines: 1,
          ),
          subtitle: Text(
            subtitle!,
            style: subtitleStyle ?? const TextStyle(color: Colors.grey),
            maxLines: 2,
          ),
          trailing: (trailing != null)
              ? trailing
              : Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Constants.kMainColor,
                ),
        ),
      ),
    );
  }
}
