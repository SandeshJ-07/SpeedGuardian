import 'package:flutter/material.dart';
import 'package:speed_guardian/utils/class.dart';
import 'package:speed_guardian/utils/utils.dart';

Color themeColor([double opacity = 1]) => Color.fromRGBO(53, 147, 175, opacity);
const Color themeBlue = Color.fromRGBO(53, 147, 175, 1);

Widget textButton(String label, Function pressEvent, BuildContext context,
    {bool disabled = false,
    double fontSize = 16,
    Color textColor = themeBlue}) {
  return TextButton(
      onPressed: () {
        if (!disabled) {
          pressEvent();
        }
      },
      child: Text(label,
          style: TextStyle(
              color: !disabled ? textColor : themeColor(0.6),
              fontSize: fontSize)));
}

Widget circularButton(Icon icon, Function pressEvent, BuildContext context,
    {double bottom = 0, double left = 0, double right = 0, double top = 0}) {
  return Positioned(
    bottom: bottom,
    right: right,
    child: ElevatedButton(
      onPressed: () {
        pressEvent();
      }, // icon of the button
      style: ElevatedButton.styleFrom(
        // styling the button
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(18),
        backgroundColor: themeColor(0.7),
        // Button color
        foregroundColor: themeColor(1),
      ),
      child: icon,
    ),
  );
}

Widget filledButton(
  String label,
  Function pressEvent,
  BuildContext context, {
  bool loading = false,
  bool disabled = false,
  bool fullWidth = false,
}) {
  return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
          width: getWidth(context, fullWidth ? 1 : 1.1),
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              if (!disabled && !loading) {
                pressEvent();
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: !disabled ? themeBlue : themeColor(0.7),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
            child: loading
                ? Image.asset("assets/images/loadingD.gif", height: 40)
                : Text(label,
                    style: const TextStyle(color: Colors.white)),
          )));
}

Widget outlinedButton(
  String label,
  Function pressEvent,
  BuildContext context, {
  bool disabled = false,
  bool fullWidth = false,
}) {
  return Center(
    child: SizedBox(
        width: getWidth(context, fullWidth ? 1 : 1.1),
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            if (!disabled) pressEvent();
          },
          style: ElevatedButton.styleFrom(
            side: const BorderSide(
                width: 1, color: Colors.black, style: BorderStyle.solid),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
          ),
          child: Text(label,
              style: const TextStyle(color: Colors.black)),
        )),
  );
}

Widget inputTextField(String? label, Icon icon,
    TextEditingController controller, BuildContext context,
    {bool? enabled = true,
    int? maxLen,
    bool obsecureText = false,
    bool error = false,
    String errorMessage = "Invalid value!"}) {
  return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("$label", style: const TextStyle(color: Colors.blueGrey)),
        const SizedBox(height: 5),
        SizedBox(
          width: MediaQuery.of(context).size.width / 1.3,
          child: TextField(
            obscureText: obsecureText,
            maxLength: maxLen,
            enabled: enabled ?? true,
            controller: controller,
            decoration: InputDecoration(
                errorText: error ? errorMessage : null,
                border: const OutlineInputBorder(),
                labelStyle: const TextStyle(color: Colors.black),
                filled: true,
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: -0.2),
                fillColor: const Color.fromRGBO(0, 0, 0, 0.06),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 1,
                      color: Color.fromRGBO(0, 0, 0, 0.06)), //<-- SEE HERE
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 1,
                      color: Color.fromRGBO(0, 0, 0, 0.06)), //<-- SEE HERE
                ),
                prefixIcon: icon),
          ),
        ),
      ]);
}

Widget dropDownField<T>(
    String label,
    Icon icon,
    T? value,
    List<DropDownMenuItemClass<T>> options,
    Function onChangeEvent,
    BuildContext context,
    {bool error = false,
    String errorMessage = ""}) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(label, style: const TextStyle(color: Colors.blueGrey)),
    SizedBox(
      width: getWidth(context, 1.3),
      child: Container(
        decoration: BoxDecoration(
            color: const Color.fromRGBO(0, 0, 0, 0.06),
            border: Border.all(
              width: 1,
              color: const Color.fromRGBO(0, 0, 0, 0.06),
            ),
            borderRadius: BorderRadius.circular(5)),
        child: DropdownButtonFormField(
            value: value,
            decoration: InputDecoration(
              prefixIcon: icon,
            ),
            style: const TextStyle(
                fontWeight: FontWeight.w600, color: Colors.black),
            isExpanded: true,
            hint: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
              child: Text(label),
            ),
            focusColor: const Color.fromRGBO(0, 0, 0, 0.06),
            items: options.map((DropDownMenuItemClass<T> item) {
              return DropdownMenuItem(value: item.value, child: item.child);
            }).toList(),
            onChanged: (T? value) {
              onChangeEvent(value);
            }),
      ),
    ),
    const SizedBox(height: 5),
    if (error)
      Text(errorMessage,
          style: TextStyle(color: Colors.red[900], fontSize: 12)),
  ]);
}

Widget displayData(String label, String? text, [Icon? icon]) {
  return Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
    if (icon != null) icon,
    const SizedBox(width: 10),
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(color: Colors.blueGrey)),
      Text(text ?? "--"),
    ]),
  ]);
}

Widget iconTextCard(String text, Icon icon, BuildContext context) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
    decoration: BoxDecoration(
      color: Colors.white70,
      borderRadius: BorderRadius.circular(3),
    ),
    constraints: BoxConstraints(minWidth: 3.5 * getWidth(context) / 8),
    child: Column(
      children: [
        icon,
        const SizedBox(height: 10),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w500),
        )
      ],
    ),
  );
}

Widget errorMessage(String text) {
  return Text(text,
      style: const TextStyle(
          color: Colors.red, fontSize: 12, fontWeight: FontWeight.w600));
}

Widget showAlertMessage(String text, BuildContext context,
    {MessageType alertType = MessageType.info}) {
  return Container(
      width: getWidth(context),
      padding: const EdgeInsets.fromLTRB(15, 10, 25, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: getAlertMessageType(alertType),
      ),
      child: Text(text));
}

Widget deviceCard(
  String name,
  String device,
  Function pressEvent, {
  EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
  EdgeInsets margin = const EdgeInsets.symmetric(vertical: 10),
}) {
  return Container(
    margin: margin,
    child: InkWell(
      onTap: () {
        pressEvent();
      },
      child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [themeColor(0.8), themeColor(0.7), themeColor(0.6)]),
            borderRadius: BorderRadius.circular(5),
          ),
          padding: padding,
          child: Row(
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(
                  children: [
                    const Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 5),
                    Text(name,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.white)),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  device,
                  style: const TextStyle(color: Colors.white),
                ),
              ]),
              const Expanded(child: SizedBox()),
              const Icon(
                Icons.arrow_forward_ios,
                color: themeBlue,
              ),
            ],
          )),
    ),
  );
}

Widget deviceCardHome(
    String name, String device, Function pressEvent, BuildContext context) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
    width: getWidth(context, 2),
    decoration: BoxDecoration(
      color:Colors.white70,
      boxShadow: const [
        BoxShadow(
          blurRadius: 3.0,
          color: Colors.black12,
        ),
      ],
      borderRadius: BorderRadius.circular(5),
    ),
    child: InkWell(
      onTap: () {
        pressEvent();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.phone_android),
          const SizedBox(height: 10,),
          Text(name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          Text(device),
        ],
      ),
    ),
  );
}

Widget addDeviceCardHome(
    Function pressEvent, BuildContext context) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
    width: getWidth(context, 2),
    decoration: BoxDecoration(
      color:Colors.white70,
      boxShadow: const [
        BoxShadow(
          blurRadius: 3.0,
          color: Colors.black12,
        ),
      ],
      borderRadius: BorderRadius.circular(5),
    ),
    child: InkWell(
      onTap: () {
        pressEvent();
      },
      child: const Center(
        child : Icon(Icons.add_circle_outline_sharp, size:50, color:Colors.blueGrey)
      )
    ),
  );
}
