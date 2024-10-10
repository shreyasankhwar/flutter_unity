import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_embed_unity/flutter_embed_unity.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {

  static final _fixedLocaleNumberFormatter = NumberFormat.decimalPatternDigits(
    locale: 'en_gb',
    decimalDigits: 2,
  );

  bool? _isUnityArSupportedOnDevice;
  bool _isArSceneActive = false;
  double _rotationSpeed = 0.0;
  int _numberOfTaps = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Golf Swing Tracer',style: TextStyle(color: Colors.white),),
        ),
        body: SafeArea(
          child: Builder(
            builder: (context) {
              final theme = Theme.of(context);
              final bool? isUnityArSupportedOnDevice =
                  _isUnityArSupportedOnDevice;
              final String arStatusMessage;

              if (isUnityArSupportedOnDevice == null) {
                arStatusMessage = "checking...";
              } else if (isUnityArSupportedOnDevice) {
                arStatusMessage = "supported";
              } else {
                arStatusMessage = "not supported on this device";
              }
              return Column(
                children: [
                  Expanded(
                    child: IgnorePointer(
                      ignoring: true,
                      child: EmbedUnity(
                        onMessageFromUnity: (String data) {
                          // A message has been received from a Unity script
                          if (data == "touch") {
                            // setState(() {
                            //   _numberOfTaps += 1;
                            // });
                          } else if (data == "scene_loaded") {
                            _sendRotationSpeedToUnity(_rotationSpeed);
                          } else if (data == "ar:true") {
                            setState(() {
                              _isUnityArSupportedOnDevice = true;
                            });
                          } else if (data == "ar:false") {
                            setState(() {
                              _isUnityArSupportedOnDevice = false;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  Container(
                    color:  const Color(0xff1e232c),
                    height: 100,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            _restartToUnity();
                          },
                          icon:const Icon(Icons.play_circle,size: 40,color: Colors.green,),
                        ),

                        Expanded(
                          child: Slider(
                            min: 0,
                            max: 200,
                            activeColor: Colors.white,
                            value: _rotationSpeed,
                            onChanged: (value) {
                              setState(() {
                                _rotationSpeed = value;
                              });
                              _sendRotationSpeedToUnity(value);
                            },
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _playToUnity();

                          },
                          icon:const Icon(Icons.restart_alt_rounded,size: 40,color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: ElevatedButton(
                  //           onPressed: () {
                  //             pauseUnity();
                  //           },
                  //           child: const Text("Pause"),
                  //         ),
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: ElevatedButton(
                  //           onPressed: () {
                  //             resumeUnity();
                  //           },
                  //           child: const Text("Resume"),
                  //         ),
                  //       ),
                  //     ),
                  //     // Expanded(
                  //     //   child: Padding(
                  //     //     padding: const EdgeInsets.all(8.0),
                  //     //     child: ElevatedButton(
                  //     //       onPressed: () {
                  //     //         Navigator.push(
                  //     //           context,
                  //     //           MaterialPageRoute(
                  //     //               builder: (context) => const Route2()),
                  //     //         );
                  //     //       },
                  //     //       child: const Text("Open route 2",
                  //     //           textAlign: TextAlign.center),
                  //     //     ),
                  //     //   ),
                  //     // ),
                  //   ],
                  // )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _sendRotationSpeedToUnity(double rotationSpeed) {
    sendToUnity(
      "FlutterLogo",
      "SetRotationSpeed",
      _fixedLocaleNumberFormatter.format(rotationSpeed),
    );
  }

  void _pauseToUnity( ) {
    sendToUnity(
      "FlutterLogo",
      "setPause",
      "",
    );
  }

/// we have change it
  void _playToUnity() {
    sendToUnity(
      "FlutterLogo",
      "setPause",
      "",
    );
  }

  void _restartToUnity() {
    sendToUnity(
      "FlutterLogo",
      "setRestart",
      "",
    );
  }
}

// class Route2 extends StatelessWidget {
//   const Route2({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Route 2'),
//         ),
//         body: SafeArea(
//           child: Builder(
//               builder: (context) => Column(
//                     children: [
//                       const Padding(
//                         padding: EdgeInsets.all(16),
//                         child: Text(
//                           "Unity can only be shown in 1 widget at a time. Therefore if a second route "
//                           "with a FlutterEmbed is pushed onto the stack, Unity is 'detached' from "
//                           "the first route, and attached to the second. When the second route is "
//                           "popped from the stack, Unity is reattached to the first route.",
//                         ),
//                       ),
//                       const Expanded(
//                         child: EmbedUnity(),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const BackButton(),
//                             ElevatedButton(
//                               onPressed: () {
//                                 showDialog(
//                                     context: context,
//                                     builder: (_) => const Route3());
//                               },
//                               child: const Text("Open route 3",
//                                   textAlign: TextAlign.center),
//                             ),
//                           ],
//                         ),
//                       )
//                     ],
//                   )),
//         ));
//   }
// }
//
// class Route3 extends StatelessWidget {
//   const Route3({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const AlertDialog(
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             "Route 3",
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(
//             height: 100,
//             width: 80,
//             child: EmbedUnity(),
//           ),
//         ],
//       ),
//     );
//   }
// }
