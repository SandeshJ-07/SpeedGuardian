import 'package:flutter/material.dart';

class Help extends StatefulWidget {
  const Help({super.key});

  @override
  HelpState createState() => HelpState();
}

class HelpState extends State<Help> {
  final List faqs = [
    {
      "index": 0,
      "question": "What is the purpose of this mobile application?",
      "answer":
          "This mobile application is designed to help parents and guardians keep track of the location and speed of their child's device for safety and peace of mind.",
    },
    {
      "index": 1,
      "question": "How does the app track the location of the child's device?",
      "answer":
          "The app uses GPS technology and location services on the child's device to determine its precise location.",
    },
    {
      "index": 2,
      "question": "Is the child's consent required to use this app?",
      "answer":
          "Yes, the child's consent and cooperation are essential. It's important to have an open conversation with your child about using this app for their safety.",
    },
    {
      "index": 3,
      "question":
          "Can I monitor the speed at which my child is traveling with this app?",
      "answer":
          "Yes, the app can track the speed of the child's device in real-time, allowing you to be aware of their movements.",
    },
    {
      "index": 4,
      "question":
          "Is the child aware that their location and speed are being monitored?",
      "answer":
          "It's crucial to inform your child that their location and speed are being tracked, as transparency and trust are essential in using this app.",
    },
    {
      "index": 5,
      "question": "How secure is the data collected by the app?",
      "answer":
          "The app takes data security seriously and employs encryption and secure protocols to protect the information collected.",
    },
    {
      "index": 6,
      "question": "Can I set up geofences with this app?",
      "answer":
          "Yes, you can set up geofences, which are virtual boundaries, to receive alerts when your child enters or leaves specific areas.",
    },
    {
      "index": 7,
      "question":
          "What devices and operating systems are supported by the app?",
      "answer":
          "The app is compatible with a range of devices and supports popular operating systems like iOS and Android.",
    },
    {
      "index": 8,
      "question": "How do I receive alerts or notifications from the app?",
      "answer":
          "You can configure the app to send you alerts and notifications via push notifications or email, depending on your preferences.",
    },
    {
      "index": 9,
      "question":
          "Is the app available for free, or is there a subscription fee?",
      "answer":
          "The app may have a free version with basic features and a premium subscription with additional functionalities. Check the app store for details.",
    },
    {
      "index": 10,
      "question": "Can I track multiple children with a single account?",
      "answer":
          "Depending on the app's features, you may be able to track multiple children using a single account.",
    },
    {
      "index": 11,
      "question":
          "What steps should I take if my child's device is lost or stolen?",
      "answer":
          "The app may offer features to help locate a lost or stolen device. Follow the app's guidelines for such situations.",
    },
  ];
  int faqNumber = 12;
  List<bool> expanded = List.filled(12, false);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Help",
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.start),
          const SizedBox(height: 10),
          ExpansionPanelList(
            expansionCallback: (panelIndex, isExpanded) {
              setState(() {
                expanded = List.filled(faqNumber, false);
                expanded[panelIndex] = isExpanded;
              });
            },
            animationDuration: const Duration(milliseconds: 700),
            children: [
              ...faqs.map((item) {
                return ExpansionPanel(
                    backgroundColor: expanded[item["index"]]
                        ? const Color.fromRGBO(53, 147, 175, 0.4)
                        : Colors.white,
                    canTapOnHeader: true,
                    headerBuilder: (context, isOpen) {
                      return Container(
                          margin: const EdgeInsets.only(top: 5),
                          padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                          child: Row(
                            children: [
                              Icon(Icons.help,
                                  color:
                                      isOpen ? Colors.white60 : Colors.black26),
                              const SizedBox(width: 10),
                              Expanded(
                                  child: Text("${item["question"]}",
                                      style: TextStyle(
                                          color: isOpen
                                              ? Colors.white
                                              : Colors.black))),
                            ],
                          ));
                    },
                    body: Container(
                      padding: const EdgeInsets.all(20),
                      color: Colors.black12,
                      width: double.infinity,
                      child: Text(item["answer"],
                          style: const TextStyle(color: Colors.white)),
                    ),
                    isExpanded: expanded[item["index"]]);
              })
            ],
          ),
          const SizedBox(height: 20),
        ],
      )),
    );
  }
}
