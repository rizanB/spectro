import 'package:flutter/material.dart';
import 'new_exp.dart';
import 'history.dart';
import 'help.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Spectroscopy Data')),
      backgroundColor: Color(0xFF193B65),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Text(
                    "Without data, you’re just another person with an opinion.",
                    style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        color: Colors.white),
                  ),
                  Text(
                    "— W. Edwards Deming",
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Stack(alignment: Alignment.center, children: [
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 8,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NewExperimentScreen()));
                    },
                    child: Container(
                      width: 320,
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 16),
                      decoration: BoxDecoration(
                          color: const Color(0xFFDC645D),
                          borderRadius: BorderRadius.circular(16)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12.0, 0, 8.0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'New',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text('plot and save observations',
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.6),
                                        fontSize: 14.0))
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white.withOpacity(0.2)),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: const Icon(
                                Icons.arrow_forward_ios,
                                size: 18.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                    top: 38,
                    bottom: 0,
                    right: 60,
                    // left: 120,
                    child: Image.asset(
                      'assets/images/flask.png',
                      height: 60,
                      width: 60,
                      // color: Colors.amber,
                    ))
              ]),
              SizedBox(
                height: 4,
              ),
              Stack(alignment: Alignment.center, children: [
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 8,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HistoryScreen()));
                    },
                    child: Container(
                      width: 320,
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 16),
                      decoration: BoxDecoration(
                          // color: const Color(0xFFDC645D),
                          borderRadius: BorderRadius.circular(16)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12.0, 0, 8.0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'History',
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text('saved experiments',
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.6),
                                        fontSize: 14.0))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Positioned(
                //     top: 38,
                //     bottom: 0,
                //     right: 60,
                //     // left: 120,
                //     child: Image.asset(
                //       'assets/images/flask.png',
                //       height: 60,
                //       width: 60,
                //       // color: Colors.amber,
                //     )
                //     )
              ]),
              SizedBox(height: 4),
              Stack(alignment: Alignment.center, children: [
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 8,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HelpScreen()));
                    },
                    child: Container(
                      width: 320,
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12.0, 0, 8.0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Help',
                                  style: TextStyle(
                                    // color: Colors.white,
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text('need help using this app?',
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.6),
                                        fontSize: 14.0))
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white.withOpacity(0.2)),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: const Icon(
                                Icons.arrow_forward_ios,
                                size: 18.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Positioned(
                //     top: 38,
                //     bottom: 0,
                //     right: 60,
                //     // left: 120,
                //     child: Image.asset(
                //       'assets/images/flask.png',
                //       height: 60,
                //       width: 60,
                //       // color: Colors.amber,
                //     ))
              ])
            ],
          ),
        ),
      ),
    );
  }
}
