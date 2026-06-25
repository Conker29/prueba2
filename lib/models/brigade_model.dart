class Brigade {
  final String id;
  final String brigadeCoordinatorId;
  final String sectorId;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Brigade({
    required this.id,
    required this.brigadeCoordinatorId,
    required this.sectorId,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
  });

  factory Brigade.fromMap(Map<String, dynamic> map) {
    return Brigade(
      id: map['id'] ?? '',
      brigadeCoordinatorId: map['brigade_coordinator_id'] ?? '',
      sectorId: map['sector_id'] ?? '',
      isActive: map['is_active'] ?? true,
      createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'brigade_coordinator_id': brigadeCoordinatorId,
      'sector_id': sectorId,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Brigade copyWith({
    String? id,
    String? brigadeCoordinatorId,
    String? sectorId,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Brigade(
      id: id ?? this.id,
      brigadeCoordinatorId: brigadeCoordinatorId ?? this.brigadeCoordinatorId,
      sectorId: sectorId ?? this.sectorId,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
