import 'package:flutter/material.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:aqua/theme_manager.dart';
import 'package:aqua/utils/widgets/universal_header.dart';
import 'package:aqua/utils/colors.dart';

import 'package:aqua/screens/settings/faqs.dart';

TextStyle headerStyle =
    const TextStyle(fontSize: 40, fontWeight: FontWeight.w900);

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
      appBar: const UniversalHeader(title: "Settings"),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("Theme", style: headerStyle),
                showThemeModeToggle()
              ]),
              const Divider(height: 30),
              Text("FAQs", style: headerStyle),
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
              Text("About", style: headerStyle),
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

    TextStyle themeToggleStyle =
        const TextStyle(fontWeight: FontWeight.bold, fontSize: 17);

    return AnimatedToggleSwitch.dual(
      borderWidth: 3,
      current: themeNotifier.isDarkMode,
      first: false,
      second: true,
      spacing: 20,
      height: 50,
      onChanged: (b) => themeNotifier.setTheme(b),
      textBuilder: (b) => b
          ? Text('Dark', style: themeToggleStyle)
          : Text('Light', style: themeToggleStyle),
      iconBuilder: (b) => b
          ? const Icon(Icons.bedtime, color: Colors.white)
          : const Icon(Icons.sunny, color: Colors.white),
      styleBuilder: (b) => ToggleStyle(
          backgroundColor: Theme.of(context).canvasColor,
          borderColor: Theme.of(context).primaryColor,
          indicatorColor: b ? AquaColors.darkBlue : AquaColors.yellow),
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
            child: Image.asset('assets/images/buy_me_a_coffee.jpg')));
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
        side: const BorderSide(color: AquaColors.darkBlue, width: 3));

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.only(left: 10),
        shape: border,
        collapsedShape: border,
        title: Text(question,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
        children: [
          Padding(padding: const EdgeInsets.all(8.0), child: Text(answer))
        ],
      ),
    );
  }
}
