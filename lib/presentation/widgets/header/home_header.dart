import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:zentinel/presentation/providers/auth/auth_provider.dart';
// import 'package:zentinel/presentation/widgets/widgets.dart';

class VideoHeader extends ConsumerStatefulWidget {
  const VideoHeader({super.key});

  @override
  ConsumerState<VideoHeader> createState() => _VideoHeaderState();
}

class _VideoHeaderState extends ConsumerState<VideoHeader> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // final authState = ref.watch(userSessionProvider);


        final headerHeight = MediaQuery.of(context).size.height * 0.24;

        return SizedBox(
          height: headerHeight,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [

                Container(color: const Color.fromARGB(255, 17, 20, 179)),

                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () => print('object'),
                              child: const Padding(
                                padding: EdgeInsets.all(7),
                                child: Icon(Icons.upload_file_rounded, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 15,),
                              const Text(
                                'Hola,',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'k',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }


  // void _openModal(BuildContext context, Widget childWidget) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     barrierColor: Colors.black54,
  //     builder: (_) {
  //       return AnimatedModal(child: childWidget);
  //     },
  //   );
  // }
}
