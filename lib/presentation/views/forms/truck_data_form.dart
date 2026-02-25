import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kontrol_app/presentation/widgets/inputs/glow_text_form_field.dart';

class TruckDataFormWidget extends StatelessWidget {
	final List<String> plateOptions;
	final String? selectedPlate;
	final ValueChanged<String?> onPlateChanged;
	final TextEditingController initialKmController;
	final List<String> fuelOptions;
	final String? selectedFuel;
	final ValueChanged<String?> onFuelChanged;
	final VoidCallback onPickImages;
	final List<File?> selectedImages;
	final Function(int) onRemoveImage;

	const TruckDataFormWidget({
		super.key,
		required this.plateOptions,
		required this.selectedPlate,
		required this.onPlateChanged,
		required this.initialKmController,
		required this.fuelOptions,
		this.selectedFuel = '0',
		required this.onFuelChanged,
		required this.onPickImages,
		required this.selectedImages,
		required this.onRemoveImage,
	});

	@override
	Widget build(BuildContext context) {
		return Column(
			children: [
				// Placa
				DropdownButtonFormField<String>(
					value: selectedPlate,
					items: plateOptions.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
					onChanged: onPlateChanged,
					decoration: InputDecoration(
						labelText: 'Placa',
						border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
						contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
					),
					validator: (v) => v == null ? 'Selecciona placa' : null,
				),
				const SizedBox(height: 16),

				// Kilometraje inicial
				TextFormField(
					controller: initialKmController,
					decoration: InputDecoration(
						labelText: 'Kilometraje inicial',
						border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
						contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
					),
					keyboardType: TextInputType.number,
					validator: (v) => (v == null || v.isEmpty) ? 'Ingresa el kilometraje' : null,
				),
				const SizedBox(height: 16),

				// Nivel combustible
				GlowDropdownFormField<String>(
					value: selectedFuel ?? '0%',
					decoration: InputDecoration(
						labelText: 'Nivel combustible salida',
						border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
						contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
					),
					items: [
						const DropdownMenuItem<String>(
							value: null,
							enabled: false,
							child: Text('Seleccione una opción'),
						),
						...fuelOptions.map(
							(f) => DropdownMenuItem<String>(
								value: f,
								child: Text(f),
							),
						)
					],
					onChanged: onFuelChanged,
					validator: (v) => v == null ? 'Selecciona nivel de combustible' : null,
				),
				const SizedBox(height: 16),

				// Registro fotográfico
				ElevatedButton.icon(
					onPressed: onPickImages,
					icon: const Icon(Icons.camera_alt),
					label: const Text('Subir registro fotográfico'),
					style: ElevatedButton.styleFrom(
						backgroundColor: Colors.white,
						foregroundColor: const Color.fromARGB(255, 4, 98, 246),
						side: const BorderSide(color: Color.fromARGB(255, 4, 98, 246)),
						padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
						shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
					),
				),
				const SizedBox(height: 12),
				Text('${selectedImages.length} archivo(s) seleccionado(s)', style: Theme.of(context).textTheme.bodySmall),
				const SizedBox(height: 16),

				// Vista previa de imágenes
				if (selectedImages.isNotEmpty)
					Container(
						padding: const EdgeInsets.all(8),
						decoration: BoxDecoration(
							border: Border.all(color: Colors.white12),
							borderRadius: BorderRadius.circular(8),
						),
						child: GridView.builder(
							shrinkWrap: true,
							physics: const NeverScrollableScrollPhysics(),
							gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
								crossAxisCount: 3,
								crossAxisSpacing: 8,
								mainAxisSpacing: 8,
							),
							itemCount: selectedImages.length,
							itemBuilder: (context, index) {
								return Stack(
									children: [
										Container(
											decoration: BoxDecoration(
												borderRadius: BorderRadius.circular(8),
												image: DecorationImage(
													image: FileImage(
														selectedImages[index]!,
													),
													fit: BoxFit.cover,
												),
											),
										),
										Positioned(
											top: -8,
											right: -8,
											child: IconButton(
												onPressed: () => onRemoveImage(index),
												icon: const Icon(
													Icons.close,
													color: Colors.red,
												),
												style: IconButton.styleFrom(
													backgroundColor: Colors.black54,
													iconSize: 16,
												),
											),
										),
									],
								);
							},
						),
					)
				else
					Center(
						child: Padding(
							padding: const EdgeInsets.symmetric(vertical: 20),
							child: Text(
								'No hay imágenes capturadas',
								style: TextStyle(color: Colors.white54),
							),
						),
					),
			],
		);
	}
}
