import 'package:flutter/material.dart';
import 'package:playhub/core/theme/app_pallete.dart';

class CoachCard extends StatelessWidget {
  final String coachName;
  final String specialization;
  final String bio;
  final bool availability;
  final String profilePictureUrl;
  final VoidCallback onBookNow;
  final int points;

  const CoachCard({
    Key? key,
    required this.coachName,
    required this.specialization,
    required this.bio,
    required this.availability,
    required this.profilePictureUrl,
    required this.onBookNow,
    required this.points,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onBookNow,
      child: Card(
        margin: const EdgeInsets.all(12.0),
        elevation: 5.0,
        color: AppPalettes.cardForeground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(profilePictureUrl),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          coachName,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppPalettes.accent),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          specialization,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        points.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                bio,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Availability: ${availability ? 'Available' : 'Not Available'}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
