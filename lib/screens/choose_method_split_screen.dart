import 'package:flutter/material.dart';
import 'package:splitbill/screens/initialize_camera.dart';
import 'package:splitbill/screens/input_total_split_screen.dart';
import 'package:splitbill/screens/take_picture_screen.dart';

class ChooseMethodSplitScreen extends StatelessWidget {
  
  const ChooseMethodSplitScreen({super.key,  required this.socialId});

  final String socialId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(25,60,25,25),
        child: Center(
          child: Column(
            children: [
              Text(
                'Choose how to split the bill',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,),
              ),
              const SizedBox(height: 25.0),
              GestureDetector(
                onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InputTotalSplitScreen(socialId: socialId)),
                );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  shadowColor: Colors.black,
                  child: SizedBox(
                    width: 300,
                    height: 200,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.edit_square,
                              size: 50.0,
                              color: Theme.of(context).colorScheme.primary),
                          const SizedBox(height: 16.0),
                          Text(
                            'Manual Input',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25.0),
              GestureDetector(
                onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InitializeCamera()),
                );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Theme.of(context).colorScheme.primary,
                  shadowColor: Colors.black,
                  child: SizedBox(
                    width: 300,
                    height: 200,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt_outlined,
                              size: 50.0,
                              color: Theme.of(context).colorScheme.secondary),
                          const SizedBox(height: 16.0),
                          Text(
                            'Scan your receipt',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color:
                                        Theme.of(context).colorScheme.secondary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
