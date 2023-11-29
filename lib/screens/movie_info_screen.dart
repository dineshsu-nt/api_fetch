// Inside MovieInfoScreen

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MovieInfoScreen extends StatelessWidget {
  const MovieInfoScreen({
    Key? key,
    required this.id,
    required this.title,
    required this.image,
    this.releaseDate,
    this.overView,
  }) : super(key: key);

  final String id;
  final String title;
  final String image;
  final String? releaseDate;
  final String? overView;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Stack(
          children: [
            Positioned(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  'https://image.tmdb.org/t/p/w342/$image',
                  width: 100.w,
                  height: 80.h,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 8),
              ],
            )),
            Positioned(
              top: 45.h,
              left: 15.w,
              child: Container(
                width: 80.w,
                height: 60.w,
                decoration: BoxDecoration(
                  color:
                      Colors.black.withOpacity(0.7), // Adjust opacity as needed
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(5.0.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              releaseDate ?? "",
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white),
                            ),
                            SizedBox(
                              width: 9.w,
                            ),
                            Icon(
                              Icons.timer,
                              color: Colors.white,
                            ),
                            Text(
                              "0 hr0 mins",
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white),
                            ),
                          ],
                        ),
                        Text(overView ?? "",
                            style:
                                TextStyle(fontSize: 10.sp, color: Colors.white),
                            maxLines: 4),
                        // Add other details here if needed
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Add more details as needed
          ],
        ),
      ),
    );
  }
}
