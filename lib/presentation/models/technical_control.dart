class TechnicalControl {
  DateTime arrivalDate;
  List<Client> clients;
  List<Copilot> copilots;
  DateTime createdAt;
  dynamic createdBy;
  String destiny;
  dynamic exitDate;
  dynamic exitPoint;
  dynamic finalGasolineId;
  dynamic nameGasolineFinal;
  dynamic nameGasolineInitial;
  String license;
  dynamic nameDriver;
  dynamic finalKm;
  dynamic initialGasolineId;
  String initialKm;
  int licenseId;
  String nameStatus;
  int statusId;
  List<Reason> reasons;
  DateTime updatedAt;
  dynamic updatedBy;
  dynamic images;

  TechnicalControl({
    required this.arrivalDate,
    required this.clients,
    required this.copilots,
    required this.createdAt,
    required this.createdBy,
    required this.destiny,
    required this.statusId,
    required this.nameStatus,
    required this.license,
    required this.exitDate,
    required this.exitPoint,
    required this.finalGasolineId,
    required this.nameGasolineFinal,
    required this.nameGasolineInitial,
    required this.images,
    required this.finalKm,
    required this.initialGasolineId,
    required this.initialKm,
    required this.nameDriver,
    required this.licenseId,
    required this.reasons,
    required this.updatedAt,
    required this.updatedBy,
  });

  factory TechnicalControl.fromJson(
    Map<String, dynamic> json,
  ) => TechnicalControl(
    arrivalDate: DateTime.parse(json["arrival_date"]),
    clients: List<Client>.from(json["clients"].map((x) => Client.fromJson(x))),
    copilots: List<Copilot>.from(
      json["copilots"].map((x) => Copilot.fromJson(x)),
    ),
    createdAt: DateTime.parse(json["created_at"]),
    createdBy: json["created_by"],
    destiny: json["destiny"],
    exitDate: json["exit_date"],
    exitPoint: json["exit_point"],
    finalGasolineId: json["final_gasoline_id"],
    finalKm: json["final_km"],
    images: json['images'],
    nameDriver: json["name_driver"],
    initialGasolineId: json["initial_gasoline_id"],
    nameGasolineInitial: json["name_gasoline_initial"],
    license: json["license"],
    statusId: json["status_id"],
    nameStatus: json["name_status"],
    nameGasolineFinal: json["name_gasoline_final"],
    initialKm: json["initial_km"],
    licenseId: json["license_id"],
    reasons: List<Reason>.from(json["reasons"].map((x) => Reason.fromJson(x))),
    updatedAt: DateTime.parse(json["updated_at"]),
    updatedBy: json["updated_by"],
  );

  Map<String, dynamic> toJson() => {
    "arrival_date": arrivalDate.toIso8601String(),
    "clients": List<dynamic>.from(clients.map((x) => x.toJson())),
    "copilots": List<dynamic>.from(copilots.map((x) => x.toJson())),
    "created_at": createdAt.toIso8601String(),
    "created_by": createdBy,
    "license": license,
    "name_gasoline_initial": nameGasolineInitial,
    "name_driver": nameDriver,
    "destiny": destiny,
    "images": images,
    "exit_date": exitDate,
    "exit_point": exitPoint,
    "status_id": statusId,
    "status_name": nameStatus,
    "final_gasoline_id": finalGasolineId,
    "name_gasoline_final": nameGasolineFinal,
    "final_km": finalKm,
    "initial_gasoline_id": initialGasolineId,
    "initial_km": initialKm,
    "license_id": licenseId,
    "reasons": List<dynamic>.from(reasons.map((x) => x.toJson())),
    "updated_at": updatedAt.toIso8601String(),
    "updated_by": updatedBy,
  };
}

class Client {
  int id;
  String name;

  Client({
    required this.id,
    required this.name
  });

  factory Client.fromJson(Map<String, dynamic> json) => Client(
    id: json["id"],
    name: json["name"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name
  };
}

class Copilot {
  int id;
  String name;

  Copilot({
    required this.id,
    required this.name
  });

  factory Copilot.fromJson(Map<String, dynamic> json) => Copilot(
    id: json["id"],
    name: json["name"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name
  };
}

class Reason {
  int id;
  String name;

  Reason({
    required this.id,
    required this.name
  });

  factory Reason.fromJson(Map<String, dynamic> json) => Reason(
    id: json["id"],
    name: json["name"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name
  };
}
