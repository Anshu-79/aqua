class FAQ {
  final String question;
  final String answer;

  FAQ({required this.question, required this.answer});
}

List<FAQ> faqs = [
  FAQ(
      question: "How does Aqua calculate my water needs?",
      answer:
          "Aqua calculates a primary AWI (Adequate Water Intake) based on your age, and then increases or decreases it based on your physical activities & your location's weather."),
  FAQ(
      question: "How accurate is the water goal Aqua calculates?",
      answer:
          "Although Aqua provides the most accurate water goal possible, it is next to impossible to calculate a person's exact water needs."),
  FAQ(
      question: "Is Aqua open-source?",
      answer:
          "Yes! Aqua is entirely open-source. You can find the URL to Aqua's GitHub repository below."),
  FAQ(
      question: "Why am I not receiving notifications?",
      answer:
          "Notification privileges might not be given to Aqua. You can go to the App Settings section of your device and change that."),
  FAQ(
      question: "How does Aqua decide when to send notifications?",
      answer:
          "The algorithm Aqua uses to send notifications is available in the below GitHub repository."),
  FAQ(
      question: "Why does Aqua ask for my sleep schedule?",
      answer:
          "Aqua uses your sleep schedule timings to ensure that hydration reminders are only sent during waking hours. Your hydration day starts when you wake up and ends when you sleep."),
  FAQ(
      question: "What does 'Water Percent' of a beverage mean?",
      answer:
          "Water Percent is used as a measure of how much a beverage contributes to your hydration. For eg: If you drink 100 mL of a beverage with water percent = 10, it will count as 10 mL."),
  FAQ(
      question: "What effect do Activities have on my water goal?",
      answer:
          "Aqua calculates the amount of water lost due to the physical activity, and increases your goal by that amount."),
  FAQ(
      question: "How can I report a bug?",
      answer: "You can report bugs on Aqua's GitHub repository."),
  FAQ(
      question: "Is my data secure?",
      answer:
          "Yes. All of your hydration data is stored locally on your device."),
  FAQ(
      question: "How can I edit my profile?",
      answer:
          "You can tap the buttons on the profile screen to edit your name, age, height, weight, etc."),
  FAQ(
      question: "How can I share my progress with my friends?",
      answer:
          "Simply tap the Share Stats button located at the bottom of the profile screen"),
  FAQ(
      question: "How do I upgrade to the premium version?",
      answer:
          "There's no premium version! Aqua provides the complete arsenal of its features for free. You could say you're already using the premium version!")
];
