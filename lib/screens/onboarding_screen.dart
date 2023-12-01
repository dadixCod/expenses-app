import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../models/models.dart';

class OnBoardingScreen extends StatefulWidget {
  final VoidCallback onBoardingCompleted;
  const OnBoardingScreen({super.key, required this.onBoardingCompleted});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  bool isLast = false;
  final onboardingList = OnBoarding.onboardingContent;
  final PageController _controller = PageController();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final buttonStyle = ButtonStyle(
    foregroundColor: MaterialStateProperty.all(Colors.black),
    backgroundColor: MaterialStateProperty.all(Colors.grey[300]),
    padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 10)),
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: PageView.builder(
              controller: _controller,
              onPageChanged: (index) {
                setState(() {
                  isLast = (index == onboardingList.length - 1);
                });
              },
              itemCount: onboardingList.length,
              itemBuilder: (_, index) {
                final onboardingItem = onboardingList[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Gap(40),
                    Image.asset(onboardingItem.image),
                    const Gap(20),
                    Text(
                      onboardingItem.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(10),
                    Text(
                      onboardingItem.description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Container(
            alignment: const Alignment(0, 0.8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //skip button
                TextButton(
                    style: buttonStyle,
                    onPressed: () {
                      _controller.jumpToPage(onboardingList.length - 1);
                    },
                    child: const Text(
                      "SKIP",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    )),
                SmoothPageIndicator(
                  controller: _controller,
                  count: onboardingList.length,
                ),

                //next or done button
                isLast
                    ? TextButton(
                        style: buttonStyle,
                        onPressed: () {
                          widget.onBoardingCompleted();
                        },
                        child: const Text(
                          "DONE",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      )
                    : TextButton(
                        style: buttonStyle,
                        onPressed: () {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Text(
                          "NEXT",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
