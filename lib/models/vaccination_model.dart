import 'enums.dart';

class Vaccination {
  final String id;
  final String vaccinatorId;
  final String sectorId;
  final String brigadeCoordinatorId;
  final String ownerName;
  final String ownerCedula;
  final String ownerPhone;
  final PetType petType;
  final String petName;
  final String petAgeApprox;
  final Gender petGender;
  final String vaccineApplied;
  final String? observations;
  final String? photoUrl;
  final double latitude;
  final double longitude;
  final DateTime vaccinationDate;
  final String? localPhotoPath;
  final SyncStatus syncStatus;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Vaccination({
    required this.id,
    required this.vaccinatorId,
    required this.sectorId,
    required this.brigadeCoordinatorId,
    required this.ownerName,
    required this.ownerCedula,
    required this.ownerPhone,
    required this.petType,
    required this.petName,
    required this.petAgeApprox,
    required this.petGender,
    required this.vaccineApplied,
    this.observations,
    this.photoUrl,
    required this.latitude,
    required this.longitude,
    required this.vaccinationDate,
    this.localPhotoPath,
    required this.syncStatus,
    required this.createdAt,
    this.updatedAt,
  });

  factory Vaccination.fromMap(Map<String, dynamic> map) {
    return Vaccination(
      id: map['id'] ?? '',
      vaccinatorId: map['vaccinator_id'] ?? '',
      sectorId: map['sector_id'] ?? '',
      brigadeCoordinatorId: map['brigade_coordinator_id'] ?? '',
      ownerName: map['owner_name'] ?? '',
      ownerCedula: map['owner_cedula'] ?? '',
      ownerPhone: map['owner_phone'] ?? '',
      petType: PetType.fromString(map['pet_type'] ?? 'dog'),
      petName: map['pet_name'] ?? '',
      petAgeApprox: map['pet_age_approx'] ?? '',
      petGender: Gender.fromString(map['pet_gender'] ?? 'male'),
      vaccineApplied: map['vaccine_applied'] ?? '',
      observations: map['observations'],
      photoUrl: map['photo_url'],
      latitude: (map['latitude'] ?? 0.0).toDouble(),
      longitude: (map['longitude'] ?? 0.0).toDouble(),
      vaccinationDate: DateTime.parse(map['vaccination_date'] ?? DateTime.now().toIso8601String()),
      localPhotoPath: map['local_photo_path'],
      syncStatus: SyncStatus.fromString(map['sync_status'] ?? 'synced'),
      createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vaccinator_id': vaccinatorId,
      'sector_id': sectorId,
      'brigade_coordinator_id': brigadeCoordinatorId,
      'owner_name': ownerName,
      'owner_cedula': ownerCedula,
      'owner_phone': ownerPhone,
      'pet_type': petType.value,
      'pet_name': petName,
      'pet_age_approx': petAgeApprox,
      'pet_gender': petGender.value,
      'vaccine_applied': vaccineApplied,
      'observations': observations,
      'photo_url': photoUrl,
      'latitude': latitude,
      'longitude': longitude,
      'vaccination_date': vaccinationDate.toIso8601String(),
      'local_photo_path': localPhotoPath,
      'sync_status': syncStatus.value,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Vaccination copyWith({
    String? id,
    String? vaccinatorId,
    String? sectorId,
    String? brigadeCoordinatorId,
    String? ownerName,
    String? ownerCedula,
    String? ownerPhone,
    PetType? petType,
    String? petName,
    String? petAgeApprox,
    Gender? petGender,
    String? vaccineApplied,
    String? observations,
    String? photoUrl,
    double? latitude,
    double? longitude,
    DateTime? vaccinationDate,
    String? localPhotoPath,
    SyncStatus? syncStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Vaccination(
      id: id ?? this.id,
      vaccinatorId: vaccinatorId ?? this.vaccinatorId,
      sectorId: sectorId ?? this.sectorId,
      brigadeCoordinatorId: brigadeCoordinatorId ?? this.brigadeCoordinatorId,
      ownerName: ownerName ?? this.ownerName,
      ownerCedula: ownerCedula ?? this.ownerCedula,
      ownerPhone: ownerPhone ?? this.ownerPhone,
      petType: petType ?? this.petType,
      petName: petName ?? this.petName,
      petAgeApprox: petAgeApprox ?? this.petAgeApprox,
      petGender: petGender ?? this.petGender,
      vaccineApplied: vaccineApplied ?? this.vaccineApplied,
      observations: observations ?? this.observations,
      photoUrl: photoUrl ?? this.photoUrl,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      vaccinationDate: vaccinationDate ?? this.vaccinationDate,
      localPhotoPath: localPhotoPath ?? this.localPhotoPath,
      syncStatus: syncStatus ?? this.syncStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
