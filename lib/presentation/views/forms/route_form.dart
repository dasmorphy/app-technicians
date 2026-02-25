import 'package:flutter/material.dart';

class RouteFormWidget extends StatelessWidget {
	final TextEditingController originController;
	final TextEditingController destinationController;
	final TextEditingController observationsController;

	const RouteFormWidget({
		super.key,
		required this.originController,
		required this.destinationController,
		required this.observationsController,
	});

	@override
	Widget build(BuildContext context) {
		return Column(
			children: [
				// Punto de salida
				TextFormField(
					controller: originController,
					decoration: InputDecoration(
						labelText: 'Punto de salida',
						border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
						contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
					),
					validator: (v) => (v == null || v.isEmpty) ? 'Ingresa punto de salida' : null,
				),
				const SizedBox(height: 16),

				// Destino
				TextFormField(
					controller: destinationController,
					decoration: InputDecoration(
						labelText: 'Destino del recorrido',
						border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
						contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
					),
					validator: (v) => (v == null || v.isEmpty) ? 'Ingresa destino' : null,
				),
				const SizedBox(height: 16),

				// Observaciones
				TextFormField(
					controller: observationsController,
					decoration: InputDecoration(
						labelText: 'Observaciones de movilización',
						border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
						contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
					),
					maxLines: 4,
				),
			],
		);
	}
}
