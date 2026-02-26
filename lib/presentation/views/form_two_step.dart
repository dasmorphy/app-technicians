import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:kontrol_app/service/movement_service.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'forms/initial_data_form.dart';
import 'forms/truck_data_form.dart';
import 'forms/personnel_form.dart';
import 'forms/route_form.dart';


class FormTwoStepView extends StatefulWidget {
	const FormTwoStepView({super.key});

	@override
	State<FormTwoStepView> createState() => _FormTwoStepViewState();
}

class _FormTwoStepViewState extends State<FormTwoStepView> {
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
	List<File?> photoFiles = [];

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
	
	// Services
	final _movementService = MovementService();
	bool _isLoading = false;

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
				return StatefulBuilder(
					builder: (context, setStateDialog) {
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
												setStateDialog(() {
													if (v == true) {
														if (!selected.contains(opt)) {
															selected.add(opt);
														}
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

  // Future<void> _captureImageFromCamera() async {
  //   if (_selectedImages.length >= 5) {
  //     if (mounted) {
  //       setState(() {
  //         imagesMinError = false;
  //         imagesMaxError = false;
  //       });
  //     }
  //   }

  //   if (_selectedImages.length >= 10) {
  //     if (mounted) {
  //       setState(() {
  //         imagesMaxError = true;
  //       });
  //     }
  //     return;
  //   }

  //   if (_selectedImages.length == 10) {
  //     imagesMaxError = false;
  //   }

  //   try {
  //     final XFile? image = await _imagePicker.pickImage(
  //       source: ImageSource.camera,
  //     );

  //     if (image != null && mounted) {
  //       // Agregar placeholder nulo para mostrar progreso en la UI
  //       setState(() {
  //         _selectedImages.add(null);
  //       });

  //       final placeholderIndex = _selectedImages.length - 1;

  //       final originalFile = File(image.path);

  //       // Convertir a WebP
  //       final webpFile = await convertToWebP(originalFile);

  //       if (webpFile == null) {
  //         if (mounted) {
  //           // Remover placeholder
  //           setState(() {
  //             if (placeholderIndex < _selectedImages.length &&
  //                 _selectedImages[placeholderIndex] == null) {
  //               _selectedImages.removeAt(placeholderIndex);
  //             }
  //           });

  //           showDialog(
  //             context: context,
  //             builder: (_) =>
  //                 ShowDialogWidget(title: 'Error al convertir imagen'),
  //           );
  //         }
  //         return;
  //       }

  //       final bytes = await webpFile.length();
  //       final mb = bytes / 1024 / 1024;

  //       print("Peso después de WebP: ${mb.toStringAsFixed(2)} MB");

  //       if (mounted) {
  //         setState(() {
  //           _selectedImages[placeholderIndex] = webpFile;
  //         });
  //       }
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       // Remover último placeholder si existe
  //       if (_selectedImages.isNotEmpty && _selectedImages.last == null) {
  //         setState(() => _selectedImages.removeLast());
  //       }
  //       showDialog(
  //         context: context,
  //         builder: (_) => ShowDialogWidget(
  //           title: 'Error al capturar imagen',
  //           content: '$e',
  //         ),
  //       );
  //     }
  //   }
  // }

  Future<File?> convertToWebP(File file) async {
    final dir = await getTemporaryDirectory();
    final targetPath = p.join(
      dir.path,
      "${DateTime.now().millisecondsSinceEpoch}.webp",
    );

    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      format: CompressFormat.webp,
      quality: 75, // Puedes bajar a 70 si quieres más compresión
    );

    if (result == null) return null;

    return File(result.path);
  }

  void _removeImage(int index) {
    setState(() {
      photoFiles.removeAt(index);
    });
  }

	Future<void> _submit() async {
		// Validate last form
		final form = _formKeys[_currentStep].currentState;
		if (form != null && !form.validate()) return;

		// Validar que todos los campos requeridos estén completos
		if (movementDateTime == null) {
			_showErrorSnackBar('Por favor selecciona fecha y hora');
			return;
		}
		if (selectedMotives.isEmpty) {
			_showErrorSnackBar('Por favor selecciona al menos un motivo');
			return;
		}
		if (selectedPlate == null) {
			_showErrorSnackBar('Por favor selecciona una placa');
			return;
		}
		if (selectedDriver == null) {
			_showErrorSnackBar('Por favor selecciona un conductor');
			return;
		}

		setState(() => _isLoading = true);

		try {
			// Convertir archivos null a File
			final List<File> validPhotos = photoFiles
				.where((photo) => photo != null)
				.map((photo) => photo!)
				.toList();

			// Crear la solicitud
			final request = MovementRequest(
				movementDateTime: movementDateTime!,
				motives: selectedMotives,
				projects: selectedProjects,
				projectOther: _projectOtherController.text.isEmpty ? null : _projectOtherController.text,
				plate: selectedPlate!,
				initialKm: _initialKmController.text,
				fuel: selectedFuel ?? '',
				driver: selectedDriver!,
				passengers: selectedPassengers,
				origin: _originController.text,
				destination: _destinationController.text,
				observations: _observationsController.text.isEmpty ? null : _observationsController.text,
				photos: validPhotos,
			);

			// Enviar al servidor
			await _movementService.submitMovement(request);

			if (mounted) {
				_showSuccessSnackBar('¡Movimiento registrado exitosamente!');
				
				// Limpiar el formulario después de 2 segundos
				await Future.delayed(const Duration(seconds: 2));
				
				if (mounted) {
					_resetForm();
				}
			}
		} on DioException catch (e) {
			if (mounted) {
				String errorMessage = 'Error al enviar el movimiento';
				if (e.response?.statusCode == 400) {
					errorMessage = 'Datos inválidos: ${e.response?.data['message'] ?? ''}';
				} else if (e.response?.statusCode == 409) {
					errorMessage = 'El movimiento ya existe';
				} else if (e.response?.statusCode == 500) {
					errorMessage = 'Error en el servidor';
				} else if (e.type == DioExceptionType.connectionTimeout) {
					errorMessage = 'Tiempo de conexión agotado';
				} else if (e.type == DioExceptionType.connectionError) {
					errorMessage = 'Error de conexión. Verifica tu conexión a internet';
				}
				_showErrorSnackBar(errorMessage);
			}
		} catch (e) {
			if (mounted) {
				_showErrorSnackBar('Error inesperado: $e');
			}
		} finally {
			if (mounted) {
				setState(() => _isLoading = false);
			}
		}
	}

	void _resetForm() {
		setState(() {
			_currentStep = 0;
			movementDateTime = null;
			_movementDateController.clear();
			selectedMotives.clear();
			selectedProjects.clear();
			_projectOtherController.clear();
			selectedPlate = null;
			_initialKmController.clear();
			selectedFuel = null;
			photoFiles.clear();
			selectedDriver = null;
			selectedPassengers.clear();
			_originController.clear();
			_destinationController.clear();
			_observationsController.clear();
		});
	}

	void _showSuccessSnackBar(String message) {
		ScaffoldMessenger.of(context).showSnackBar(
			SnackBar(
				content: Row(
					children: [
						const Icon(Icons.check_circle, color: Colors.white),
						const SizedBox(width: 12),
						Expanded(child: Text(message)),
					],
				),
				backgroundColor: Colors.green[700],
				behavior: SnackBarBehavior.floating,
				margin: const EdgeInsets.all(16),
			),
		);
	}

	void _showErrorSnackBar(String message) {
		ScaffoldMessenger.of(context).showSnackBar(
			SnackBar(
				content: Row(
					children: [
						const Icon(Icons.error_outline, color: Colors.white),
						const SizedBox(width: 12),
						Expanded(child: Text(message)),
					],
				),
				backgroundColor: Colors.red[700],
				behavior: SnackBarBehavior.floating,
				margin: const EdgeInsets.all(16),
			),
		);
	}

	@override
	Widget build(BuildContext context) {
		final stepTitles = ['Datos iniciales', 'Datos de la camioneta', 'Personal a bordo', 'Ruta'];
		final stepSubtitles = ['Movimiento', 'Camioneta', 'Personal', 'Ruta'];

		return Scaffold(
			body: SafeArea(
				child: Column(
					children: [
						// Header with step indicator
						Container(
							color: Colors.grey[50],
							padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
							child: Column(
								children: [
									// Title
									Text(
										stepTitles[_currentStep],
										style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
										textAlign: TextAlign.center,
									),
									const SizedBox(height: 24),

									// Step Indicator
									_buildStepIndicator(stepSubtitles),
								],
							),
						),

						// Form Content
						Expanded(
							child: SingleChildScrollView(
								padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
								child: _buildFormContent(),
							),
						),

						// Navigation Buttons
						Container(
							padding: const EdgeInsets.all(24),
							color: Colors.grey[50],
							child: Column(
								mainAxisSize: MainAxisSize.min,
								children: [
									SizedBox(
										width: double.infinity,
										height: 48,
										child: ElevatedButton(
											onPressed: _isLoading ? null : (_currentStep == 3 ? _submit : _nextStep),
											style: ElevatedButton.styleFrom(
												backgroundColor: const Color.fromARGB(255, 4, 98, 246),
												shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
												disabledBackgroundColor: Colors.grey[300],
											),
											child: _isLoading
												? Row(
													mainAxisAlignment: MainAxisAlignment.center,
													children: [
														const SizedBox(
															width: 20,
															height: 20,
															child: CircularProgressIndicator(
																strokeWidth: 2,
																valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
															),
														),
														const SizedBox(width: 12),
														const Text(
															'Enviando...',
															style: TextStyle(
																fontSize: 16,
																fontWeight: FontWeight.bold,
																color: Colors.white,
																letterSpacing: 0.5,
															),
														),
													],
												)
												: Text(
													_currentStep == 3 ? 'ENVIAR' : 'SIGUIENTE',
													style: const TextStyle(
														fontSize: 16,
														fontWeight: FontWeight.bold,
														color: Colors.white,
														letterSpacing: 0.5,
													),
												),
										),
									),
									if (_currentStep > 0) ...[
										const SizedBox(height: 12),
										SizedBox(
											width: double.infinity,
											height: 48,
											child: OutlinedButton(
												onPressed: _previousStep,
												style: OutlinedButton.styleFrom(
													side: const BorderSide(color: Color.fromARGB(255, 4, 98, 246), width: 2),
													shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
												),
												child: const Text(
													'ATRÁS',
													style: TextStyle(
														fontSize: 16,
														fontWeight: FontWeight.bold,
														color: Color.fromARGB(255, 87, 83, 83),
														letterSpacing: 0.5,
													),
												),
											),
										),
									],
								],
							),
						),
					],
				),
			),
		);
	}

	Widget _buildStepIndicator(List<String> subtitles) {
		return Row(
			mainAxisAlignment: MainAxisAlignment.center,
			children: List.generate(4, (index) {
				final isActive = index == _currentStep;
				final isCompleted = index < _currentStep;
				final color = isActive || isCompleted ? const Color.fromARGB(255, 4, 98, 246) : Colors.grey[300];
				final textColor = isActive ? const Color.fromARGB(255, 4, 98, 246) : Colors.grey[400];

				return Expanded(
					child: Row(
						children: [
							Expanded(
								child: Column(
									children: [
										Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
											width: 48,
											height: 48,
											decoration: BoxDecoration(
												shape: BoxShape.circle,
												color: color,
											),
											child: Center(
												child: Text(
													'${index + 1}',
													style: const TextStyle(
														color: Colors.white,
														fontWeight: FontWeight.bold,
														fontSize: 16,
													),
												),
											),
										),
										const SizedBox(height: 8),
										Text(
											subtitles[index],
											textAlign: TextAlign.center,
											style: TextStyle(
												fontSize: 10,
												color: textColor,
												fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
											),
										),
									],
								),
							),
							if (index < 3)
								Container(
									height: 2,
									width: 24,
									color: index < _currentStep ? const Color.fromARGB(255, 4, 98, 246) : Colors.grey[300],
									margin: const EdgeInsets.only(top: 0),
								),
						],
					),
				);
			}),
		);
	}

	Widget _buildFormContent() {
		final forms = [
			Form(
				key: _formKeys[0],
				child: InitialDataFormWidget(
					movementDateController: _movementDateController,
					onPickDateTime: _pickDateTime,
					motiveOptions: motiveOptions,
					selectedMotives: selectedMotives,
					onSelectMotives: (vals) => setState(() => selectedMotives = vals ?? []),
					projectOptions: projectOptions,
					selectedProjects: selectedProjects,
					onSelectProjects: (vals) => setState(() => selectedProjects = vals ?? []),
					projectOtherController: _projectOtherController,
					onShowMultiSelect: _showMultiSelect,
				),
			),
			Form(
				key: _formKeys[1],
				child: TruckDataFormWidget(
					plateOptions: plateOptions,
					selectedPlate: selectedPlate,
					onPlateChanged: (v) => setState(() => selectedPlate = v),
					initialKmController: _initialKmController,
					fuelOptions: fuelOptions,
					selectedFuel: selectedFuel,
					onFuelChanged: (v) => setState(() => selectedFuel = v),
					onPickImages: _pickImages,
					selectedImages: photoFiles,
					onRemoveImage: _removeImage,
				),
			),
			Form(
				key: _formKeys[2],
				child: PersonnelFormWidget(
					driverOptions: driverOptions,
					selectedDriver: selectedDriver,
					onDriverChanged: (v) => setState(() => selectedDriver = v),
					passengerOptions: passengerOptions,
					selectedPassengers: selectedPassengers,
					onSelectPassengers: (vals) => setState(() => selectedPassengers = vals ?? []),
					onShowMultiSelect: _showMultiSelect,
				),
			),
			Form(
				key: _formKeys[3],
				child: RouteFormWidget(
					originController: _originController,
					destinationController: _destinationController,
					observationsController: _observationsController,
				),
			),
		];

		return forms[_currentStep];
	}
}

