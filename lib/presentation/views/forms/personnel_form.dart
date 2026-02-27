import 'package:flutter/material.dart';

class PersonnelFormWidget extends StatelessWidget {
	final List<dynamic> driverOptions; // lista de objetos del API
  final int? selectedDriver;         // id seleccionado
  final ValueChanged<int?> onDriverChanged;
	final List<dynamic> passengerOptions;
	final List<int> selectedPassengers;
  final List<String> selectedCopilotNames;
	final ValueChanged<List<int>?> onSelectPassengers;
	final Future<List<int>?> Function(String, List<dynamic>, List<int>) onShowMultiSelect;

	const PersonnelFormWidget({
		super.key,
		required this.driverOptions,
		required this.selectedDriver,
    required this.selectedCopilotNames,
		required this.onDriverChanged,
		required this.passengerOptions,
		required this.selectedPassengers,
		required this.onSelectPassengers,
		required this.onShowMultiSelect,
	});

	@override
	Widget build(BuildContext context) {
		return Column(
			children: [
				// Conductor
				DropdownButtonFormField<int>(
					initialValue: selectedDriver,
					items: driverOptions.map<DropdownMenuItem<int>>((driver) {
            return DropdownMenuItem<int>(
              value: driver['id_driver'],          // 👈 se guarda el id
              child: Text(driver['name']),  // 👈 se muestra el nombre
            );
          }).toList(),
					onChanged: onDriverChanged,
					decoration: InputDecoration(
						labelText: 'Conductor',
						border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
						contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
					),
					validator: (v) => v == null ? 'Selecciona conductor' : null,
				),
				const SizedBox(height: 16),

				// Personal acompañante
				// ElevatedButton(
				// 	onPressed: () async {
				// 		final res = await onShowMultiSelect('Personal acompañante', passengerOptions, selectedPassengers);
				// 		if (res != null) onSelectPassengers(res);
				// 	},
				// 	style: ElevatedButton.styleFrom(
				// 		backgroundColor: Colors.white,
				// 		foregroundColor: const Color(0xFFE74C3C),
				// 		side: const BorderSide(color: Color(0xFFE74C3C)),
				// 		padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
				// 		shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
				// 	),
				// 	child: SizedBox(
				// 		width: double.infinity,
				// 		child: Row(
				// 			mainAxisAlignment: MainAxisAlignment.spaceBetween,
				// 			children: [
				// 				Text(selectedPassengers.isEmpty ? 'Seleccionar personal acompañante' : selectedPassengers.join(', ')),
				// 				const Icon(Icons.arrow_drop_down),
				// 			],
				// 		),
				// 	),
				// ),

        ElevatedButton(
          onPressed: () async {
            final res = await onShowMultiSelect(
              'Personal acompañante',
              passengerOptions,
              selectedPassengers,
            );
            if (res != null) onSelectPassengers(res);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            // foregroundColor: const Color(0xFFE74C3C),
            side: const BorderSide(color: Color.fromARGB(255, 94, 92, 92)),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    selectedCopilotNames.isEmpty
                      ? 'Seleccionar personal acompañante'
                      : selectedCopilotNames.join(', '),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2, // puedes usar 1 si prefieres
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
			],
		);
	}
}
