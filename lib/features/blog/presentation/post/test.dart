// import 'package:dropdown_button2/dropdown_button2.dart'
//     show
//         ButtonStyleData,
//         DropdownButton2,
//         DropdownStyleData,
//         IconStyleData,
//         MenuItemStyleData;
// import 'package:flutter/material.dart';
// import 'package:flutter_application_2/comment.dart';
// import 'package:flutter_dash/flutter_dash.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final List<String> items = ['Item1', 'Item2', 'Item3', 'Item4'];
//   String? selectedValue;
//   Widget buildComment(Comment comment, int level) {
//     return Padding(
//       padding: EdgeInsets.only(left: level * 20.0, top: 10, bottom: 10),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Column(
//             children: [
//               CircleAvatar(
//                 backgroundColor: Colors.amber,
//                 //  backgroundImage: AssetImage(comment.profileImage)
//               ),
//               if (comment.replies.isNotEmpty)
//                 Dash(
//                   direction: Axis.vertical,
//                   length: 40 * comment.replies.length.toDouble(),
//                   dashColor: Colors.grey,
//                 ),
//             ],
//           ),
//           SizedBox(width: 10),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       comment.user,
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(width: 5),
//                     Text(
//                       comment.date,
//                       style: TextStyle(color: Colors.grey, fontSize: 12),
//                     ),
//                   ],
//                 ),
//                 Text(comment.text),
//                 Row(
//                   children: [
//                     TextButton(
//                       onPressed: () {},
//                       child: Text(
//                         "Reply",
//                         style: TextStyle(color: Colors.blue),
//                       ),
//                     ),
//                     if (comment.replies.isNotEmpty)
//                       TextButton.icon(
//                         onPressed: () {},
//                         icon: Icon(
//                           Icons.expand_more,
//                           size: 16,
//                           color: Colors.amber,
//                         ),
//                         label: Text(
//                           "${comment.replies.length} Replies",
//                           style: TextStyle(color: Colors.amber),
//                         ),
//                       ),
//                   ],
//                 ),
//                 if (comment.replies.isNotEmpty)
//                   Column(
//                     children:
//                         comment.replies
//                             .asMap()
//                             .entries
//                             .map(
//                               (entry) => buildReply(
//                                 entry.value,
//                                 level + 1,
//                                 entry.key,
//                                 comment.replies.length,
//                               ),
//                             )
//                             .toList(),
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildReply(Comment reply, int level, int index, int totalReplies) {
//     bool isFirst = index == 0;
//     bool isLast = index == totalReplies - 1;

//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Column(
//           children: [
//             Dash(
//               direction: Axis.vertical,
//               length: isLast ? 0 : 30,
//               dashColor: Colors.grey,
//             ),
//             Row(
//               children: [
//                 if (isFirst || isLast)
//                   Dash(
//                     direction: Axis.horizontal,
//                     length: 50,
//                     dashColor: Colors.grey,
//                   ),
//                 CircleAvatar(
//                   backgroundColor: Colors.green,
//                   // backgroundImage: AssetImage(reply.profileImage)
//                 ),
//               ],
//             ),
//           ],
//         ),
//         SizedBox(width: 10),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Text(
//                     reply.user,
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(width: 5),
//                   Text(
//                     reply.date,
//                     style: TextStyle(color: Colors.grey, fontSize: 12),
//                   ),
//                 ],
//               ),
//               Text(reply.text),
//               TextButton(
//                 onPressed: () {},
//                 child: Text("Reply", style: TextStyle(color: Colors.blue)),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView(
//         padding: EdgeInsets.all(10),
//         children:
//             Comment.comments
//                 .map((comment) => buildComment(comment, 0))
//                 .toList(),
//       ),
//       // body: Center(
//       //   child: DropdownButtonHideUnderline(
//       //     child: DropdownButton2<String>(
//       //       isExpanded: true,
//       //       hint: const Row(
//       //         children: [
//       //           SizedBox(width: 4),
//       //           Expanded(
//       //             child: Text(
//       //               "DD",
//       //               style: TextStyle(
//       //                 fontSize: 14,
//       //                 fontWeight: FontWeight.bold,
//       //                 color: Colors.black,
//       //               ),
//       //               overflow: TextOverflow.ellipsis,
//       //             ),
//       //           ),
//       //         ],
//       //       ),
//       //       items:
//       //           items
//       //               .map(
//       //                 (String item) => DropdownMenuItem<String>(
//       //                   value: item,
//       //                   child: Text(
//       //                     item,
//       //                     style: const TextStyle(
//       //                       fontSize: 14,
//       //                       fontWeight: FontWeight.bold,
//       //                       color: Colors.black,
//       //                     ),
//       //                     overflow: TextOverflow.ellipsis,
//       //                   ),
//       //                 ),
//       //               )
//       //               .toList(),
//       //       value: selectedValue,
//       //       onChanged: (value) {
//       //         setState(() {
//       //           selectedValue = value;
//       //         });
//       //       },
//       //       buttonStyleData: ButtonStyleData(
//       //         height: 50,
//       //         width: 160,
//       //         padding: const EdgeInsets.only(left: 14, right: 14),
//       //         decoration: BoxDecoration(
//       //           borderRadius: BorderRadius.circular(10),
//       //           border: Border.all(color: Colors.black26),
//       //           color: Colors.grey,
//       //         ),
//       //         elevation: 2,
//       //       ),
//       //       iconStyleData: const IconStyleData(
//       //         icon: Icon(Icons.arrow_forward_ios_outlined),
//       //         iconSize: 14,
//       //         iconEnabledColor: Colors.black,
//       //         iconDisabledColor: Colors.grey,
//       //       ),
//       //       dropdownStyleData: DropdownStyleData(
//       //         maxHeight: 200,
//       //         width: 200,
//       //         decoration: BoxDecoration(
//       //           borderRadius: BorderRadius.circular(14),
//       //           color: Colors.white,
//       //         ),
//       //         offset: const Offset(-20, 0),
//       //         scrollbarTheme: ScrollbarThemeData(
//       //           radius: const Radius.circular(40),
//       //           thickness: MaterialStateProperty.all(6),
//       //           thumbVisibility: MaterialStateProperty.all(true),
//       //         ),
//       //       ),
//       //       menuItemStyleData: const MenuItemStyleData(
//       //         height: 40,
//       //         padding: EdgeInsets.only(left: 14, right: 14),
//       //       ),
//       //     ),
//       //   ),
//       // ),
//     );
//   }
// }