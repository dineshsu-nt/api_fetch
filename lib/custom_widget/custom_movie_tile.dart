
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomMovieTile extends StatelessWidget {
  final String posterPath;
  final String title;
  final String overview;

  const CustomMovieTile({
    Key? key,
    required this.posterPath,
    required this.title,
    required this.overview,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.orangeAccent,
      title: Column(
        children: [
          Row(
            children: [
              Image.network(
                'https://image.tmdb.org/t/p/w342/$posterPath',
                width: 20.w,
                height: 15.h,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: EdgeInsets.only(left: 7.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 65.w,
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    SizedBox(
                      width: 65.w,
                      child: Text(
                        overview,
                        maxLines: 4,
                        style: TextStyle(fontSize: 10.sp),
                      ),
                    ),
                    Divider(
                      thickness: 0.5.h,
                      color: Colors.orange,
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}