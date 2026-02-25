import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FormStepView extends StatefulWidget {
	const FormStepView({super.key});

	@override
	State<FormStepView> createState() => _FormStepViewState();
}

class _FormStepViewState extends State<FormStepView> {
	int _currentStep = 0;

	// Controllers / state for all fields
	DateTime? movementDateTime;
	final TextEditingController _movementDateController = TextEditingController();

	List<String> motiveOptions = [
		'Inspección',
		'Entrega',
		'Recolección',
		'Otro',
	];
	List<String> selectedMotives = [];

	List<String> projectOptions = ['Cliente A', 'Cliente B', 'Otro'];
	List<String> selectedProjects = [];
	final TextEditingController _projectOtherController = TextEditingController();

	// Truck data
	List<String> plateOptions = ['ABC-123', 'CDE-456', 'FGH-789'];
	String? selectedPlate;
	final TextEditingController _initialKmController = TextEditingController();
	List<String> fuelOptions = ['0%', '25%', '50%', '75%', '100%'];
	String? selectedFuel;
	List<File> photoFiles = [];

	// Personnel
	List<String> driverOptions = ['Juan', 'María', 'Carlos'];
	String? selectedDriver;
	List<String> passengerOptions = ['Acompañante 1', 'Acompañante 2'];
	List<String> selectedPassengers = [];

	// Route
	final TextEditingController _originController = TextEditingController();
	final TextEditingController _destinationController = TextEditingController();
	final TextEditingController _observationsController = TextEditingController();

	final _formKeys = List.generate(4, (_) => GlobalKey<FormState>());

	@override
	void dispose() {
		_movementDateController.dispose();
		_projectOtherController.dispose();
		_initialKmController.dispose();
		_originController.dispose();
		_destinationController.dispose();
		_observationsController.dispose();
		super.dispose();
	}

	Future<void> _pickDateTime() async {
		final date = await showDatePicker(
			context: context,
			initialDate: movementDateTime ?? DateTime.now(),
			firstDate: DateTime(2000),
			lastDate: DateTime(2100),
		);
		if (date == null) return;
		final time = await showTimePicker(
			context: context,
			initialTime: TimeOfDay.fromDateTime(movementDateTime ?? DateTime.now()),
		);
		if (time == null) return;
		setState(() {
			movementDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
			_movementDateController.text = movementDateTime.toString();
		});
	}

	Future<void> _pickImages() async {
		final result = await FilePicker.platform.pickFiles(
			allowMultiple: true,
			type: FileType.image,
		);
		if (result == null) return;
		setState(() {
			photoFiles = result.paths.where((p) => p != null).map((p) => File(p!)).toList();
		});
	}

	Future<List<String>?> _showMultiSelect(String title, List<String> options, List<String> initial) async {
		final selected = List<String>.from(initial);
		final res = await showDialog<List<String>>(
			context: context,
			builder: (context) {
				return AlertDialog(
					title: Text(title),
					content: SizedBox(
						width: double.maxFinite,
						child: ListView.builder(
							shrinkWrap: true,
							itemCount: options.length,
							itemBuilder: (context, index) {
								final opt = options[index];
								final checked = selected.contains(opt);
								return CheckboxListTile(
									value: checked,
									title: Text(opt),
									onChanged: (v) {
										setState(() {
											if (v == true) {
												selected.add(opt);
											} else {
												selected.remove(opt);
											}
										});
									},
								);
							},
						),
					),
					actions: [
						TextButton(onPressed: () => Navigator.pop(context, null), child: const Text('Cancelar')),
						ElevatedButton(onPressed: () => Navigator.pop(context, selected), child: const Text('Aceptar')),
					],
				);
			},
		);
		return res;
	}

	void _nextStep() {
		final form = _formKeys[_currentStep].currentState;
		if (form != null && !form.validate()) return;
		if (_currentStep < 3) {
			setState(() => _currentStep += 1);
		}
	}

	void _previousStep() {
		if (_currentStep > 0) setState(() => _currentStep -= 1);
	}

	void _submit() {
		// Validate last form
		final form = _formKeys[_currentStep].currentState;
		if (form != null && !form.validate()) return;

		final collected = {
			'movementDateTime': movementDateTime?.toIso8601String(),
			'motives': selectedMotives,
			'projects': selectedProjects,
			'projectOther': _projectOtherController.text,
			'plate': selectedPlate,
			'initialKm': _initialKmController.text,
			'fuel': selectedFuel,
			'photosCount': photoFiles.length,
			'driver': selectedDriver,
			'passengers': selectedPassengers,
			'origin': _originController.text,
			'destination': _destinationController.text,
			'observations': _observationsController.text,
		};

		// For demo: print collected
		debugPrint('Form submitted: $collected');

		ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Formulario enviado (ver consola)')));
	}

	@override
	Widget build(BuildContext context) {
		final stepTitles = ['Datos iniciales', 'Camioneta', 'Personal a bordo', 'Ruta'];
		final stepSubtitles = ['Movimiento', 'Vehículo', 'Personal', 'Destino'];

		return Center(
			child: ConstrainedBox(
				constraints: const BoxConstraints(maxWidth: 600),
				child: Card(
					margin: const EdgeInsets.all(16),
					elevation: 8,
					shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
					child: Padding(
						padding: const EdgeInsets.all(32.0),
						child: Column(
							mainAxisSize: MainAxisSize.min,
							crossAxisAlignment: CrossAxisAlignment.center,
							children: [
								// Title
								Text(
									stepTitles[_currentStep],
									style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
									textAlign: TextAlign.center,
								),
								const SizedBox(height: 32),

								// Step Indicator
								_buildStepIndicator(stepSubtitles),
								const SizedBox(height: 32),

								// Form content
								Flexible(
									child: SingleChildScrollView(
										child: _buildFormContent(),
									),
								),
								const SizedBox(height: 24),

								// Buttons
								Row(
									children: [
										if (_currentStep > 0)
											Expanded(
												child: OutlinedButton(
													onPressed: _previousStep,
													style: OutlinedButton.styleFrom(
														padding: const EdgeInsets.symmetric(vertical: 12),
														side: const BorderSide(color: Color(0xFFE74C3C)),
													),
													child: const Text(
														'Atrás',
														style: TextStyle(color: Color(0xFFE74C3C)),
													),
												),
											),
										if (_currentStep > 0) const SizedBox(width: 12),
										Expanded(
											child: ElevatedButton(
												onPressed: _currentStep == 3 ? _submit : _nextStep,
												style: ElevatedButton.styleFrom(
													backgroundColor: const Color(0xFFE74C3C),
													padding: const EdgeInsets.symmetric(vertical: 12),
													shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
												),
												child: Text(
													_currentStep == 3 ? 'ENVIAR' : 'SIGUIENTE',
													style: const TextStyle(
														fontSize: 14,
														fontWeight: FontWeight.bold,
														color: Colors.white,
													),
												),
											),
										),
									],
								),
							],
						),
					),
				),
			),
		);
	}

	Widget _buildStepIndicator(List<String> subtitles) {
		return Column(
			children: [
				Row(
					mainAxisAlignment: MainAxisAlignment.center,
					children: List.generate(4, (index) {
						final isActive = index == _currentStep;
						final isCompleted = index < _currentStep;
						final color = isActive || isCompleted ? const Color(0xFFE74C3C) : Colors.grey[300];

						return Expanded(
							child: Row(
								children: [
									Expanded(
										child: Column(
											children: [
												Container(
													width: 50,
													height: 50,
													decoration: BoxDecoration(
														shape: BoxShape.circle,
														color: color,
													),
													child: Center(
														child: Text(
															'${index + 1}',
															style: TextStyle(
																color: Colors.white,
																fontWeight: FontWeight.bold,
																fontSize: 18,
															),
														),
													),
												),
												const SizedBox(height: 8),
												Text(
													subtitles[index],
													textAlign: TextAlign.center,
													style: TextStyle(
														fontSize: 12,
														color: isActive || isCompleted ? const Color(0xFFE74C3C) : Colors.grey,
														fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
													),
												),
											],
										),
									),
									if (index < 3)
										Container(
											height: 2,
											width: 30,
											color: index < _currentStep ? const Color(0xFFE74C3C) : Colors.grey[300],
										),
								],
							),
						);
					}),
				),
			],
		);
	}

	Widget _buildFormContent() {
		final forms = [
			Form(
				key: _formKeys[0],
				child: InitialDataForm(
					movementDateController: _movementDateController,
					onPickDateTime: _pickDateTime,
					motiveOptions: motiveOptions,
					selectedMotives: selectedMotives,
					onSelectMotives: (vals) => setState(() => selectedMotives = vals ?? []),
					projectOptions: projectOptions,
					selectedProjects: selectedProjects,
					onSelectProjects: (vals) => setState(() => selectedProjects = vals ?? []),
					projectOtherController: _projectOtherController,
				),
			),
			Form(
				key: _formKeys[1],
				child: TruckDataForm(
					plateOptions: plateOptions,
					selectedPlate: selectedPlate,
					onPlateChanged: (v) => setState(() => selectedPlate = v),
					initialKmController: _initialKmController,
					fuelOptions: fuelOptions,
					selectedFuel: selectedFuel,
					onFuelChanged: (v) => setState(() => selectedFuel = v),
					onPickImages: _pickImages,
					photos: photoFiles,
				),
			),
			Form(
				key: _formKeys[2],
				child: PersonnelForm(
					driverOptions: driverOptions,
					selectedDriver: selectedDriver,
					onDriverChanged: (v) => setState(() => selectedDriver = v),
					passengerOptions: passengerOptions,
					selectedPassengers: selectedPassengers,
					onSelectPassengers: (vals) => setState(() => selectedPassengers = vals ?? []),
				),
			),
			Form(
				key: _formKeys[3],
				child: RouteForm(
					originController: _originController,
					destinationController: _destinationController,
					observationsController: _observationsController,
				),
			),
		];

		return forms[_currentStep];
	}
}

class InitialDataForm extends StatelessWidget {
	final TextEditingController movementDateController;
	final VoidCallback onPickDateTime;
	final List<String> motiveOptions;
	final List<String> selectedMotives;
	final ValueChanged<List<String>?> onSelectMotives;
	final List<String> projectOptions;
	final List<String> selectedProjects;
	final ValueChanged<List<String>?> onSelectProjects;
	final TextEditingController projectOtherController;

	const InitialDataForm({
		Key? key,
		required this.movementDateController,
		required this.onPickDateTime,
		required this.motiveOptions,
		required this.selectedMotives,
		required this.onSelectMotives,
		required this.projectOptions,
		required this.selectedProjects,
		required this.onSelectProjects,
		required this.projectOtherController,
	}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				TextFormField(
					controller: movementDateController,
					readOnly: true,
					decoration: const InputDecoration(labelText: 'Fecha y hora del movimiento'),
					onTap: onPickDateTime,
					validator: (v) => (v == null || v.isEmpty) ? 'Selecciona fecha y hora' : null,
				),
				const SizedBox(height: 12),
				Row(
					children: [
						Expanded(
							child: ElevatedButton(
								onPressed: () async {
									final res = await (FormStepViewExtension.of(context)?._showMultiSelect('Motivo(s)', motiveOptions, selectedMotives));
									if (res != null) onSelectMotives(res);
								},
								child: const Text('Seleccionar motivo(s)'),
							),
						),
						const SizedBox(width: 12),
						Expanded(child: Text(selectedMotives.join(', '))),
					],
				),
				const SizedBox(height: 12),
				Row(
					children: [
						Expanded(
							child: ElevatedButton(
								onPressed: () async {
									final res = await (FormStepViewExtension.of(context)?._showMultiSelect('Proyecto(s)', projectOptions, selectedProjects));
									if (res != null) onSelectProjects(res);
								},
								child: const Text('Seleccionar proyecto/cliente'),
							),
						),
						const SizedBox(width: 12),
						Expanded(child: Text(selectedProjects.join(', '))),
					],
				),
				const SizedBox(height: 8),
				if (selectedProjects.contains('Otro'))
					TextFormField(
						controller: projectOtherController,
						decoration: const InputDecoration(labelText: 'Especificar otro proyecto/cliente'),
						validator: (v) {
							if (selectedProjects.contains('Otro') && (v == null || v.isEmpty)) return 'Especifica el proyecto/cliente';
							return null;
						},
					),
			],
		);
	}
}

class TruckDataForm extends StatelessWidget {
	final List<String> plateOptions;
	final String? selectedPlate;
	final ValueChanged<String?> onPlateChanged;
	final TextEditingController initialKmController;
	final List<String> fuelOptions;
	final String? selectedFuel;
	final ValueChanged<String?> onFuelChanged;
	final VoidCallback onPickImages;
	final List<File> photos;

	const TruckDataForm({
		Key? key,
		required this.plateOptions,
		required this.selectedPlate,
		required this.onPlateChanged,
		required this.initialKmController,
		required this.fuelOptions,
		required this.selectedFuel,
		required this.onFuelChanged,
		required this.onPickImages,
		required this.photos,
	}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return Column(
			children: [
				DropdownButtonFormField<String>(
					value: selectedPlate,
					items: plateOptions.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
					onChanged: onPlateChanged,
					decoration: const InputDecoration(labelText: 'Placa'),
					validator: (v) => v == null ? 'Selecciona placa' : null,
				),
				const SizedBox(height: 12),
				TextFormField(
					controller: initialKmController,
					decoration: const InputDecoration(labelText: 'Kilometraje inicial'),
					keyboardType: TextInputType.number,
					validator: (v) => (v == null || v.isEmpty) ? 'Ingresa el kilometraje' : null,
				),
				const SizedBox(height: 12),
				DropdownButtonFormField<String>(
					value: selectedFuel,
					items: fuelOptions.map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
					onChanged: onFuelChanged,
					decoration: const InputDecoration(labelText: 'Nivel combustible salida'),
					validator: (v) => v == null ? 'Selecciona nivel de combustible' : null,
				),
				const SizedBox(height: 12),
				Row(
					children: [
						ElevatedButton(onPressed: onPickImages, child: const Text('Subir registro fotográfico')),
						const SizedBox(width: 12),
						Text('${photos.length} archivo(s)')
					],
				),
				const SizedBox(height: 8),
				if (photos.isNotEmpty)
					SizedBox(
						height: 120,
						child: ListView.separated(
							scrollDirection: Axis.horizontal,
							itemCount: photos.length,
							separatorBuilder: (_, __) => const SizedBox(width: 8),
							itemBuilder: (context, index) {
								final f = photos[index];
								return Image.file(f, width: 120, height: 120, fit: BoxFit.cover);
							},
						),
					),
			],
		);
	}
}

class PersonnelForm extends StatelessWidget {
	final List<String> driverOptions;
	final String? selectedDriver;
	final ValueChanged<String?> onDriverChanged;
	final List<String> passengerOptions;
	final List<String> selectedPassengers;
	final ValueChanged<List<String>?> onSelectPassengers;

	const PersonnelForm({
		Key? key,
		required this.driverOptions,
		required this.selectedDriver,
		required this.onDriverChanged,
		required this.passengerOptions,
		required this.selectedPassengers,
		required this.onSelectPassengers,
	}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return Column(
			children: [
				DropdownButtonFormField<String>(
					value: selectedDriver,
					items: driverOptions.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
					onChanged: onDriverChanged,
					decoration: const InputDecoration(labelText: 'Conductor'),
					validator: (v) => v == null ? 'Selecciona conductor' : null,
				),
				const SizedBox(height: 12),
				Row(
					children: [
						Expanded(
							child: ElevatedButton(
								onPressed: () async {
									final res = await (FormStepViewExtension.of(context)?._showMultiSelect('Personal acompañante', passengerOptions, selectedPassengers));
									if (res != null) onSelectPassengers(res);
								},
								child: const Text('Seleccionar personal acompañante'),
							),
						),
						const SizedBox(width: 12),
						Expanded(child: Text(selectedPassengers.join(', '))),
					],
				),
			],
		);
	}
}

class RouteForm extends StatelessWidget {
	final TextEditingController originController;
	final TextEditingController destinationController;
	final TextEditingController observationsController;

	const RouteForm({
		Key? key,
		required this.originController,
		required this.destinationController,
		required this.observationsController,
	}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return Column(
			children: [
				TextFormField(
					controller: originController,
					decoration: const InputDecoration(labelText: 'Punto de salida'),
					validator: (v) => (v == null || v.isEmpty) ? 'Ingresa punto de salida' : null,
				),
				const SizedBox(height: 12),
				TextFormField(
					controller: destinationController,
					decoration: const InputDecoration(labelText: 'Destino del recorrido'),
					validator: (v) => (v == null || v.isEmpty) ? 'Ingresa destino' : null,
				),
				const SizedBox(height: 12),
				TextFormField(
					controller: observationsController,
					decoration: const InputDecoration(labelText: 'Observaciones de movilización'),
					maxLines: 3,
				),
			],
		);
	}
}

// Helper to access private methods inside the state from children
extension FormStepViewExtension on FormStepView {
	static _FormStepViewState? of(BuildContext context) {
		final state = context.findAncestorStateOfType<_FormStepViewState>();
		return state;
	}
}

