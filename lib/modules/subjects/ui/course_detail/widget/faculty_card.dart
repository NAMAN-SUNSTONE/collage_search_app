import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../theme/colors.dart';
import '../../../data/faculty_model.dart';
// import 'package:hub/data/student/models/faculty_model.dart';
// import 'package:hub/theme/colors.dart';

class FacultyCard extends StatelessWidget {
  const FacultyCard({Key? key, required this.faculty}) : super(key: key);
  final Faculty faculty;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: faculty.picture.isNotEmpty
                          ? DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(faculty.picture),
                      )
                          : null),
                  child: faculty.picture.isNotEmpty
                      ? null
                      : Icon(Icons.account_circle,size: 52, color: HubColor.grey4.withOpacity(0.5),)
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        faculty.name,
                        style: context.textTheme.headline5
                            ?.copyWith(fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        faculty.expertise
                            .map((e) => e.expertise)
                            .toList()
                            .join(', '),
                        style: context.textTheme.headline5?.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: HubColor.grey1.withOpacity(0.4)),
                      ),

                    ],
                  ),
                ),

              ],
            ),
          ],
        ));
  }
}
