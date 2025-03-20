import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerList extends StatelessWidget {
  const ShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color baseColor = isDarkMode ? Colors.grey : Colors.grey.shade600;
    Color highlightColor = isDarkMode ? Colors.grey.shade700 : Colors.grey.shade100;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 200, // Image height
                    color: Colors.black12,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 100,
                              height: 16, // Placeholder for the source like "BBC News"
                              color: Colors.black12,
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: 150,
                              height: 12, // Placeholder for the date
                              color: Colors.black12,
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              height: 16, // Placeholder for the title
                              color: Colors.black12,
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: 250,
                              height: 16, // Placeholder for the subtitle
                              color: Colors.black12,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 24,
                        height: 24, // Placeholder for the like icon
                        color: Colors.black12,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
