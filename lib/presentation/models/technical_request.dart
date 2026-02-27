import 'dart:io';

class TechnicalRequest {
  final DateTime movementDateTime;
  final List<int> motives;
  final List<String> projects;
  final String? projectOther;
  final int plate;
  final String initialKm;
  final int fuel;
  final int driver;
  final List<int> passengers;
  final String origin;
  final String destination;
  final String? observations;
  final List<File> photos;
  final String channel;
  final String externalTransactionId;

  TechnicalRequest({
    required this.movementDateTime,
    required this.motives,
    required this.projects,
    this.projectOther,
    required this.plate,
    required this.initialKm,
    required this.fuel,
    required this.driver,
    required this.passengers,
    required this.origin,
    required this.destination,
    this.observations,
    this.channel = 'TECHNICAL MOVIL',
    required this.photos,
    this.externalTransactionId = ''
  });

  /// Convertir a JSON para enviar al servidor
  Map<String, dynamic> toJson() {
    return {
      'movementDateTime': movementDateTime.toIso8601String(),
      'reasons': motives,
      'project': projects,
      'projectOther': projectOther,
      'id_truck_license': plate,
      'initial_km': initialKm,
      'initial_gasoline_id': fuel,
      'id_driver': driver,
      'driver_companion': passengers,
      'exit_point': origin,
      'destiny': destination,
      'observations': observations,
      'initial_images': photos,
      'channel': channel,
      'external_transaction_id': externalTransactionId,
    };
  }
}