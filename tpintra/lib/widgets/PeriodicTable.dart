import 'AtomImage.dart';
import 'package:tp_shouvik/data/PeriodicTableJSON.json.dart';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:tp_shouvik/model/TableElement.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PeriodicTable extends StatefulWidget {
  const PeriodicTable({Key? key, required this.title});
  final String title;

  @override
  State<PeriodicTable> createState() => _PeriodicTableState();
}

class _PeriodicTableState extends State<PeriodicTable> {
  @override
  Widget build(BuildContext context) {
    final jsonToList = jsonDecode(jsonTablePer);
    final elementList = jsonToList['elements'];
    final elements = [];

    const Gradient blueRedGradient = LinearGradient(
      colors: [Colors.blue, Colors.red],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    elementList.forEach((element) {
      elements.add(TableElement.fromJson(element));
    });

    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.title),
        ),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Container(
              height: constraints.maxHeight,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: List.generate(10, (rowIndex) {
                    return Row(
                      children: List.generate(18, (colIndex) {
                        TableElement? elem = elements.firstWhere(
                          (elem) =>
                              elem?.xpos - 1 == colIndex &&
                              elem?.ypos - 1 == rowIndex,
                          orElse: () => null,
                        );
                        if (elem != null) {
                          return SizedBox(
                            child: Expanded(
                                child: Stack(children: [
                              Container(
                                width: 80,
                                height: constraints.maxHeight / 10 -
                                    4, //Ce calcule fonctionne toujours avec ce tableau a cause du nombre de row et le margin specific
                                margin: const EdgeInsets.all(2),
                                decoration: elem.cpkHex != null
                                    ? BoxDecoration(
                                        color: Color(
                                            int.parse('0XFF${elem.cpkHex}')))
                                    : const BoxDecoration(
                                        gradient: blueRedGradient),
                                child: Center(
                                  child: elementDialog(
                                      elem, (constraints.maxHeight / 10 - 4)),
                                ),
                              ),
                              if (constraints.maxHeight / 11 > 50) ...[
                                Positioned(
                                    top: 0,
                                    left: 3,
                                    child: Text(elem.number.toString())),
                                Positioned(
                                    bottom: 1, left: 3, child: Text(elem.name)),
                                Positioned(
                                    top: 0,
                                    right: 3,
                                    child: Text(
                                        elem.atomicMass.toStringAsFixed(2)))
                              ]
                            ])),
                          );
                        } else {
                          return SizedBox(
                            child: Expanded(
                              child: Container(
                                width: 80,
                                height: constraints.maxHeight / 10 - 4,
                                margin: const EdgeInsets.all(2),
                                color: Colors.white,
                              ),
                            ),
                          );
                        }
                      }).toList(),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ));
  }

  Widget elementDialog(TableElement elem, double elementHeight) {
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return SimpleDialog(
                title: Center(
                    child: Text(elem.name, style: TextStyle(fontSize: 32))),
                children: <Widget>[
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 300),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("La masse: ${elem.atomicMass} \n",
                              style: const TextStyle(fontSize: 30)),
                          Text("Le point d'ebullition: ${elem.boil} \n",
                              style: const TextStyle(fontSize: 30)),
                          Text("La categorie: ${elem.category} \n",
                              style: const TextStyle(fontSize: 30)),
                          Text("Le point de fusion: ${elem.melt} \n",
                              style: const TextStyle(fontSize: 30)),
                          Text("La phase: ${elem.phase} \n",
                              style: const TextStyle(fontSize: 30)),
                          Text("Decouvert par: ${elem.discoveredBy} \n",
                              style: const TextStyle(fontSize: 30)),
                          Text("Description: ${elem.summary} \n",
                              style: const TextStyle(fontSize: 30)),
                          Text(
                            "Symbole: ${elem.symbol} \n",
                            style: const TextStyle(fontSize: 30),
                          ),
                          CustomPaint(
                            size: const Size(350, 350),
                            painter: AtomImage(elem.period, elem.number),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            });
      },
      child: Container(
        height: elementHeight,
        width: 80,
        child: Center(
          child: Text(elem.symbol, style: const TextStyle(fontSize: 22)),
        ),
      ),
    );
  }
}



//   Widget elementDialog(TableElement elem, double elementHeight) {
//     return InkWell(
//       onTap: () {
//         Navigator.of(context).push(PageRouteBuilder(
//           pageBuilder: (context, animation, secondaryAnimation) {
//             return FadeTransition(
//               opacity: animation,
//               child: Hero(
//                 tag: 'element-${elem.name}',
//                 child: SimpleDialog(
//                   title: Center(
//                     child: Text(elem.name, style: TextStyle(fontSize: 32)),
//                   ),
//                   children: <Widget>[
//                     ConstrainedBox(
//                       constraints: const BoxConstraints(maxHeight: 300),
//                       child: SingleChildScrollView(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "La masse: ${elem.atomicMass} \n",
//                               style: const TextStyle(fontSize: 30),
//                             ),
//                             Text(
//                               "Le point d'ebullition: ${elem.boil} \n",
//                               style: const TextStyle(fontSize: 30),
//                             ),
//                             Text(
//                               "La categorie: ${elem.category} \n",
//                               style: const TextStyle(fontSize: 30),
//                             ),
//                             Text(
//                               "Le point de fusion: ${elem.melt} \n",
//                               style: const TextStyle(fontSize: 30),
//                             ),
//                             Text(
//                               "La phase: ${elem.phase} \n",
//                               style: const TextStyle(fontSize: 30),
//                             ),
//                             Text(
//                               "Decouvert par: ${elem.discoveredBy} \n",
//                               style: const TextStyle(fontSize: 30),
//                             ),
//                             Text(
//                               "Description: ${elem.summary} \n",
//                               style: const TextStyle(fontSize: 30),
//                             ),
//                             Text(
//                               "Symbole: ${elem.symbol} \n",
//                               style: const TextStyle(fontSize: 30),
//                             ),
//                             CustomPaint(
//                               size: const Size(350, 350),
//                               painter: AtomImage(elem.period, elem.number),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                     ElevatedButton(
//                       child: const Text('OK'),
//                       onPressed: () {
//                         Navigator.of(context).pop(); // Return from the dialog
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ));
//       },
//       child: Container(
//         height: elementHeight,
//         width: 80,
//         child: Center(
//           child: Hero(
//             tag: 'element-${elem.name}',
//             child: Text(
//               elem.symbol,
//               style: const TextStyle(fontSize: 22),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }