import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:aqua/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:aqua/utils.dart' as utils;

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.prefs});
  final SharedPreferences prefs;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const utils.UniversalHeader(title: "Settings"),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("Theme", style: utils.ThemeText.settingsHeader),
                showThemeModeToggle()
              ]),
              const Divider(height: 30),
              Text("FAQs", style: utils.ThemeText.settingsHeader),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: faqs.length,
                  itemBuilder: (context, index) {
                    final question = faqs[index].question;
                    final answer = faqs[index].answer;

                    return FAQCard(question: question, answer: answer);
                  }),
              const Divider(height: 30),
              Text("About", style: utils.ThemeText.settingsHeader),
              const GitHubCard(),
              const SizedBox(height: 20),
              const BuyMeACoffeeCard(),
              const SizedBox(height: 20),
              const Divider(height: 30),
              const Center(
                  child: Text("Made in India 🇮🇳",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20))),
              const SizedBox(height: 10),
              const Center(
                  child: Text("💙 With love, Anshu79",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20))),
            ],
          ),
        ),
      ),
    );
  }

  Widget showThemeModeToggle() {
    final themeNotifier = ThemeNotifier.of(context);

    return AnimatedToggleSwitch.dual(
      borderWidth: 3,
      current: themeNotifier.isDarkMode,
      first: false,
      second: true,
      spacing: 20,
      height: 50,
      onChanged: (b) => themeNotifier.setTheme(b),
      textBuilder: (b) => b
          ? Text('Dark', style: utils.ThemeText.themeToggle)
          : Text('Light', style: utils.ThemeText.themeToggle),
      iconBuilder: (b) => b
          ? const Icon(Icons.bedtime, color: Colors.white)
          : const Icon(Icons.sunny, color: Colors.white),
      styleBuilder: (b) => ToggleStyle(
          backgroundColor: Theme.of(context).canvasColor,
          borderColor: Theme.of(context).primaryColor,
          indicatorColor: b
              ? utils.defaultColors['violet']
              : utils.defaultColors['yellow']),
    );
  }
}

class GitHubCard extends StatelessWidget {
  const GitHubCard({super.key});

  @override
  Widget build(BuildContext context) {
    final Uri url = Uri.parse('https://github.com/Anshu-79/aqua');

    Future<void> openPage() async {
      if (!await launchUrl(url)) throw Exception('Could not launch $url');
    }

    return GestureDetector(
        onTap: openPage,
        child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF28A745),
                      Color(0xFF0366D6),
                      Color(0xFF6F42C1),
                    ]),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: Theme.of(context).primaryColor, width: 3)),
            child: Row(children: [
              Image.asset('assets/images/github_logo.png', height: 90),
              const Text("github.com/Anshu-79/aqua",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16))
            ])));
  }
}

class BuyMeACoffeeCard extends StatelessWidget {
  const BuyMeACoffeeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final Uri url = Uri.parse('https://www.buymeacoffee.com/anshu79');

    Future<void> openPage() async {
      if (!await launchUrl(url)) throw Exception('Could not launch $url');
    }

    return GestureDetector(
        onTap: openPage,
        child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: const Color(0xFFffde59),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: Theme.of(context).primaryColor, width: 3)),
            child: Image.asset('assets/images/buy_me_a_coffee.jpeg')));
  }
}

class FAQCard extends StatelessWidget {
  const FAQCard({super.key, required this.question, required this.answer});
  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    final border = ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: BorderSide(color: utils.defaultColors['dark blue']!, width: 3));

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.only(left: 10),
        shape: border,
        collapsedShape: border,
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(answer),
          )
        ],
      ),
    );
  }
}

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
  FAQ(question: "How can I share my progress with my friends?", answer: ""),
  FAQ(
      question: "How do I upgrade to the premium version?",
      answer:
          "There's no premium version! Aqua provides the complete arsenal of its features for free. You could say you're already using the premium version!")
];
