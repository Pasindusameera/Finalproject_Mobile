import 'package:flutter/material.dart';
import 'package:playhub/core/api/coach_api.dart';
import 'package:playhub/core/api/customer_api.dart';
import 'package:playhub/core/common/widgets/custom_app_bar.dart';
import 'package:playhub/core/common/widgets/custom_button.dart';
import 'package:playhub/core/theme/app_pallete.dart';
import 'package:playhub/features/customer_screens/coach/widgets/review_card.dart';

class CoachReviewScreen extends StatefulWidget {
  final String coachId;
  const CoachReviewScreen({super.key, required this.coachId});

  @override
  State<CoachReviewScreen> createState() => _CoachReviewScreenState();
}

class _CoachReviewScreenState extends State<CoachReviewScreen> {
  List<dynamic>? reviews;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchReviews();
  }

  Future<void> fetchCustomerDetailsForReviews() async {
    List<Map<String, dynamic>> enrichedReviews = [];

    if (reviews == null) return; // Exit if reviews are null

    for (var review in reviews!) {
      try {
        final Map<String, dynamic> reviewMap =
            Map<String, dynamic>.from(review);
        final customer =
            await CustomerAPI.fetchCustomerById(reviewMap['customerId']);
        reviewMap['customerDetails'] = Map<String, dynamic>.from(customer);
        enrichedReviews.add(reviewMap);
      } catch (e) {
        debugPrint('Error fetching customer details: $e');
      }
    }

    setState(() {
      reviews = enrichedReviews;
    });
  }

  Future<void> fetchReviews() async {
    try {
      final List<dynamic> fetchedReviews =
          await CoachAPI.fetchCoachReviews(widget.coachId);
      setState(() {
        reviews = fetchedReviews
            .map((review) => Map<String, dynamic>.from(review))
            .toList();
        isLoading = false;
      });

      await fetchCustomerDetailsForReviews();
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load reviews. Please try again later.';
      });
      debugPrint('Error fetching reviews: $e');
    }
  }

  void _showAddReviewForm(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String reviewText = '';
    double rating = 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      backgroundColor: AppPalettes.primary,
      builder: (BuildContext context) {
        final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
        return Padding(
          padding: EdgeInsets.only(
            bottom: bottomPadding,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add a Review',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppPalettes.accent,
                  ),
                ),
                const SizedBox(height: 16),
                // Rating input
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Rating (1-5)',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a rating.';
                    }
                    final enteredRating = double.tryParse(value);
                    if (enteredRating == null ||
                        enteredRating < 1 ||
                        enteredRating > 5) {
                      return 'Please enter a valid rating between 1 and 5.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    rating = double.parse(value!);
                  },
                ),
                const SizedBox(height: 16),
                // Review text input
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Your Review',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please write a review.';
                    }
                    return null;
                  },
                  style: TextStyle(color: Colors.white),
                  onSaved: (value) {
                    reviewText = value!;
                  },
                ),
                const SizedBox(height: 16),
                // Submit button
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        _submitReview(rating, reviewText);
                        Navigator.pop(context);
                        debugPrint(
                            'Review submitted: Rating - $rating, Review - $reviewText, Coach ID - ${widget.coachId}');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppPalettes.accent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        color: AppPalettes.primary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  void _submitReview(double rating, String reviewText) async {
    setState(() {
      isLoading = true;
    });

    try {
      await CustomerAPI.AddReview(widget.coachId, rating, reviewText);
      await fetchReviews();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Review submitted successfully!'),
          duration: Duration(seconds: 2),
          backgroundColor: AppPalettes.primary,
        ),
      );
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to submit the review. Error: ${e.toString()}';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit the review. Please try again.'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
      debugPrint('Error submitting review: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // New method to build the review list
  Widget _buildReviewList() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (errorMessage.isNotEmpty) {
      return Center(child: Text(errorMessage));
    } else if (reviews == null || reviews!.isEmpty) {
      return const Center(child: Text('No reviews available.'));
    } else {
      return ListView.builder(
        itemCount: reviews?.length ?? 0,
        itemBuilder: (context, index) {
          final review = reviews![index];
          return ReviewCard(onBookNow: () {}, review: review);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        text: 'Reviews',
      ),
      body: RefreshIndicator(
        onRefresh: fetchReviews,
        child: _buildReviewList(),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomButton(
          onPressed: () => _showAddReviewForm(context),
          text: 'Add Review',
        ),
      ),
    );
  }
}
