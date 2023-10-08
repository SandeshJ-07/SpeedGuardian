import 'package:flutter/material.dart';
import 'package:speed_guardian/utils/utils.dart';

class PilotCode extends StatefulWidget {
  final String? code;

  const PilotCode(this.code, {super.key});

  @override
  PilotCodeState createState() => PilotCodeState();
}

class PilotCodeState extends State<PilotCode> {
  late String? code = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      code = widget.code??"";
    });
  }

  @override
  Widget build(BuildContext context) {
    if(code == "" || code == null) return Container();
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: InkWell(
        onTap: () async {
          await copyToClipboard(code??"");
          if (context.mounted) {
            openSnackbar(context, "Code copied to clipboard");
          }
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
              color: const Color.fromRGBO(47, 147, 175, 0.3),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Guardian Code",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 15)),
                      const SizedBox(height: 15),
                      Row(children: [
                        const Icon(Icons.code, size: 25),
                        const SizedBox(width: 10),
                        Text(code??"",
                            style: Theme.of(context).textTheme.bodyLarge),
                      ]),
                    ],
                  ),
                  const Expanded(child: SizedBox()),
                  const Icon(Icons.copy),
                ],
              )),
        ),
      ),
    );
  }
}
