import 'package:flutter/material.dart';

class InitialDataFormWidget extends StatelessWidget {
	final TextEditingController movementDateController;
	final VoidCallback onPickDateTime;
	final List<String> motiveOptions;
	final List<String> selectedMotives;
	final ValueChanged<List<String>?> onSelectMotives;
	final List<String> projectOptions;
	final List<String> selectedProjects;
	final ValueChanged<List<String>?> onSelectProjects;
	final TextEditingController projectOtherController;
	final Future<List<String>?> Function(String, List<String>, List<String>) onShowMultiSelect;

	const InitialDataFormWidget({
		super.key,
		required this.movementDateController,
		required this.onPickDateTime,
		required this.motiveOptions,
		required this.selectedMotives,
		required this.onSelectMotives,
		required this.projectOptions,
		required this.selectedProjects,
		required this.onSelectProjects,
		required this.projectOtherController,
		required this.onShowMultiSelect,
	});

	@override
	Widget build(BuildContext context) {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				// Fecha y hora del movimiento
				TextFormField(
					controller: movementDateController,
					readOnly: true,
					decoration: InputDecoration(
						labelText: 'Fecha y hora del movimiento',
						border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
						contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
					),
					onTap: onPickDateTime,
					validator: (v) => (v == null || v.isEmpty) ? 'Selecciona fecha y hora' : null,
				),
				const SizedBox(height: 16),

				// Motivo de visualización
				ElevatedButton(
					onPressed: () async {
						final res = await onShowMultiSelect('Motivo(s)', motiveOptions, selectedMotives);
						if (res != null) onSelectMotives(res);
					},
					style: ElevatedButton.styleFrom(
						backgroundColor: Colors.white,
						// foregroundColor: const Color(0xFFE74C3C),
						side: const BorderSide(color: Color.fromARGB(255, 94, 92, 92)),
						padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
						shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
					),
					child: SizedBox(
						width: double.infinity,
						child: Row(
							mainAxisAlignment: MainAxisAlignment.spaceBetween,
							children: [
								Text(selectedMotives.isEmpty ? 'Seleccionar motivo(s)' : selectedMotives.join(', ')),
								const Icon(Icons.arrow_drop_down),
							],
						),
					),
				),
				const SizedBox(height: 16),

				// Proyecto / Cliente
				ElevatedButton(
					onPressed: () async {
						final res = await onShowMultiSelect('Proyecto/Cliente', projectOptions, selectedProjects);
						if (res != null) onSelectProjects(res);
					},
					style: ElevatedButton.styleFrom(
						backgroundColor: Colors.white,
						foregroundColor: const Color(0xFFE74C3C),
						side: const BorderSide(color: Color(0xFFE74C3C)),
						padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
						shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
					),
					child: SizedBox(
						width: double.infinity,
						child: Row(
							mainAxisAlignment: MainAxisAlignment.spaceBetween,
							children: [
								Text(selectedProjects.isEmpty ? 'Seleccionar proyecto/cliente' : selectedProjects.join(', ')),
								const Icon(Icons.arrow_drop_down),
							],
						),
					),
				),
				const SizedBox(height: 16),

				// Campo "Otro" si está seleccionado
				if (selectedProjects.contains('Otro'))
					TextFormField(
						controller: projectOtherController,
						decoration: InputDecoration(
							labelText: 'Especificar otro proyecto/cliente',
							border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
							contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
						),
						validator: (v) {
							if (selectedProjects.contains('Otro') && (v == null || v.isEmpty)) {
								return 'Especifica el proyecto/cliente';
							}
							return null;
						},
					),
			],
		);
	}
}
