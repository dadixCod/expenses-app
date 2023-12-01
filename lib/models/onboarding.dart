class OnBoarding {
  final String image;
  final String title;
  final String description;
  OnBoarding({
    required this.image,
    required this.title,
    required this.description,
  });

  static List<OnBoarding> onboardingContent = [
    OnBoarding(
      image: 'assets/images/first.png',
      title: 'Effortless Expense Calculation',
      description: "Say goodbye to complex calculations! Our app simplifies expense tracking by automatically calculating your spendings.",
    ),
    OnBoarding(
      image: 'assets/images/second.png',
      title: 'Explore the World, Track Your Journey',
      description: "Embark on a seamless expense-tracking adventure as you explore the world.",
    ),
    OnBoarding(
      image: 'assets/images/third.png',
      title: 'Track Every Penny, Anytime, Anywhere',
      description: "Take control of your finances on the go. Our app ensures real-time expense monitoring wherever life takes you.",
    ),
  ];
}
