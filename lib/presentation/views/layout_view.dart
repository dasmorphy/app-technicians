import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kontrol_app/config/utils/helper.dart';
import 'package:kontrol_app/presentation/providers/providers.dart';
import 'package:kontrol_app/presentation/widgets/header/home_header.dart';
import 'package:kontrol_app/presentation/widgets/widgets.dart';

class LayoutView extends ConsumerStatefulWidget {
  const LayoutView({super.key});

  @override
  LayoutViewState createState() => LayoutViewState();
}

class LayoutViewState extends ConsumerState<LayoutView> {
  //SINO SE ESPECIFICA NOTIFIER DEVUELVE EL ESTADO POR DEFECTO, ES DECIR EL VALOR DE ESE PROVIDER

  @override
  void initState() {
    //En los metodos llmar el metodo read en los providers (flutter favorite)
    super.initState();
    // ref.read(getHistoryLogbooks.notifier).load();
    // ref.read(getAllCategories.notifier).load();
    // ref.read(getGroupBusinessByIdBusiness.notifier).load();
    // ref.read(getAllUnitiesWeight.notifier).load();
    // ref.read(popularMoviesProvider.notifier).loadNextPage();
    // ref.read(upcomingMoviesProvider.notifier).loadNextPage();
    // ref.read(topRatedMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const VideoHeader(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                

                // const SizedBox(height: 32),
                // // Título Monitoreo
                // Text(
                //   'Monitoreo',
                //   style: Theme.of(context).textTheme.titleLarge?.copyWith(
                //     color: Colors.white,
                //     fontWeight: FontWeight.w600,
                //   ),
                // ),
                // const SizedBox(height: 5),
                // // Grilla de Cámaras 2x2
                // GridView.count(
                //   crossAxisCount: 2,
                //   shrinkWrap: true,
                //   physics: const NeverScrollableScrollPhysics(),
                //   crossAxisSpacing: 12,
                //   mainAxisSpacing: 12,
                //   children: List.generate(
                //     4,
                //     (index) => _buildCameraCard(context, 'Cámara ${index + 1}'),
                //   ),
                // ),
                // const SizedBox(height: 32),

                // Bitácoras Recientes
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Bitácoras recientes',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          Column(
                            children: [
                              SizedBox(height: 4),
                              const Icon(
                                Icons.chevron_right,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // ..._buildBitacoraItems(context),
                    ],
                  ),
                ),

                const SizedBox(height: 15),
                // Publicidad
              ],
            ),
          ),
        ],
      ),
    );
  }


//   List<Widget> _buildBitacoraItems(BuildContext context) {
//     final historyLogbooks = ref.watch(getHistoryLogbooks);
//     final limitedList = historyLogbooks.take(5).toList();

//     if (historyLogbooks.isEmpty) {
//       return [
//         const Text(
//           'No hay registros',
//           style: TextStyle(color: Colors.white54),
//         )
//       ];
//     }

//     return List.generate(limitedList.length, (index) {
//       final item = limitedList[index];

//       final isEntry = item.containsKey('id_logbook_entry');
//       final typeText = isEntry ? 'ingreso' : 'salida';

//       final createdBy = item['name_user'] ?? '—';
//       final groupName = item['group_name'] ?? '—';

//       final description = isEntry
//           ? 'Bitácora de $typeText en $groupName'
//           : 'Bitácora de $typeText en $groupName';

//       final formattedDate = formatDate(item['created_at']);

//       return Padding(
//         padding: const EdgeInsets.only(bottom: 12),
//         child: InkWell(
//           borderRadius: BorderRadius.circular(8),
//           onTap: () => _openModal(context, BitacoraDetailModal(item: item)),
//           child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // Icono check
//             Container(
//               width: 24,
//               height: 24,
//               decoration: BoxDecoration(
//                 color: const Color.fromARGB(255, 4, 88, 99),
//                 borderRadius: BorderRadius.circular(4),
//               ),
//               child: const Icon(
//                 Icons.edit_note_sharp,
//                 color: Colors.white,
//                 size: 16,
//               ),
//             ),
//             const SizedBox(width: 12),
//             // Nombre y descripción
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     createdBy,
//                     style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   const SizedBox(height: 2),
//                   Text(
//                     description,
//                     style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                       color: const Color.fromARGB(255, 180, 180, 180),
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                   const SizedBox(height: 2),
//                   Text(
//                     formattedDate,
//                     style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                       color: const Color.fromARGB(255, 180, 180, 180),
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // Chevron
//             const Icon(Icons.chevron_right, color: Colors.white, size: 20),
//           ],
//         ),
//         ),
//       );
//     });
//   }

//   void _openModal(BuildContext context, Widget childWidget) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       barrierColor: Colors.black54,
//       builder: (_) {
//         return AnimatedModal(child: childWidget);
//       },
//     );
//   }
}
