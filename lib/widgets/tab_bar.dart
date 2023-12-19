import 'package:admin_hub_app/widgets/reusables.dart';
import 'package:flutter/material.dart';

import '../theme/colors.dart';
// import 'package:hub/theme/colors.dart';
// import 'package:hub/widgets/reusables.dart';

class CustomTabObject {
  late final String title;
  late final Widget child;
  CustomTabObject({required this.title, required this.child});
}

class CustomTabView1 extends StatelessWidget {
  final int selectedTab;
  final List<CustomTabObject> tabs;
  final void Function(int)? onTabChange;
  final Color selectedColor;
  const CustomTabView1(
      {required this.tabs,
        Key? key,
        required this.selectedTab,
        this.selectedColor = HubColor.iconColorCircle,
        this.onTabChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (tabs.isEmpty) return SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for (int i = 0; i < tabs.length; i++)
                Padding(
                  padding:  EdgeInsets.only( left: i== 0 ? 12.0 : 0.0),
                  child: Row(
                    children: [
                      _Tab1(
                        name: tabs[i].title,
                        isSelected: selectedTab == i,
                        onTap: onTabChange,
                        id: i,
                        selectedColor: selectedColor,
                      ),
                      SpaceHorizontal(factor: 1)
                    ],
                  ),
                )
            ],
          ),
        ),
        Space(
          height: 20,
        ),
        tabs[selectedTab].child
      ],
    );
  }
}

class _Tab1 extends StatelessWidget {
  final int id;
  final String name;
  final bool isSelected;
  final void Function(int)? onTap;
  final Color selectedColor;
  const _Tab1(
      {Key? key,
      required this.name,
      required this.isSelected,
      required this.onTap,
      required this.id,
       this.selectedColor  =  HubColor.iconColorTriangle
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () {
        if (onTap != null) onTap!(id);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: isSelected ? selectedColor : null,
            border:
            isSelected?null:Border.all(color: HubColor.grey1.withOpacity(0.1), width: 1)),
        child: Text(
          name,
          style: isSelected
              ? TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: HubColor.white)
              : TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: HubColor.grey1.withOpacity(0.7)),
        ),
      ),
    );
  }
}

///custom tab view type 2
class CustomTabView2 extends StatelessWidget {
  final int selectedTab;
  final List<CustomTabObject> tabs;
  final void Function(int)? onTabChange;
  const CustomTabView2(
      {required this.tabs,
      Key? key,
      required this.selectedTab,
      this.onTabChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
     
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            height: 36,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xff96C0D9).withOpacity(0.2)),
            child: Row(
              children: [
                for (int i = 0; i < tabs.length; i++)
                  _Tab2(
                    id: i,
                    name: tabs[i].title,
                    isSelected: selectedTab == i,
                    onTap: onTabChange,
                  )
              ],
            ),
          ),
        ),
        tabs[selectedTab].child
      ],
    );
  }
}

class _Tab2 extends StatelessWidget {
  final int id;
  final String name;
  final bool isSelected;
  final void Function(int)? onTap;
  const _Tab2(
      {Key? key,
      required this.name,
      required this.isSelected,
      required this.onTap,
      required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          if (onTap != null) onTap!(id);
        },

        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: isSelected ? HubColor.white : null),
          alignment: Alignment.center,
          margin: EdgeInsets.all(4),
          child: Text(
            name,
            style: isSelected
                ? TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: HubColor.primary)
                : TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: HubColor.grey1.withOpacity(0.7)),
          ),
        ),
      ),
    );
  }
}
