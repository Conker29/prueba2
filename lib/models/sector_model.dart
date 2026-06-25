class Sector {
  final String id;
  final String nombre;
  final String descripcion;
  final String? campaignCoordinatorId;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Sector({
    required this.id,
    required this.nombre,
    required this.descripcion,
    this.campaignCoordinatorId,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
  });

  factory Sector.fromMap(Map<String, dynamic> map) {
    return Sector(
      id: map['id'] ?? '',
      nombre: map['nombre'] ?? '',
      descripcion: map['descripcion'] ?? '',
      campaignCoordinatorId: map['campaign_coordinator_id'],
      isActive: map['is_active'] ?? true,
      createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'campaign_coordinator_id': campaignCoordinatorId,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Sector copyWith({
    String? id,
    String? nombre,
    String? descripcion,
    String? campaignCoordinatorId,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Sector(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      campaignCoordinatorId: campaignCoordinatorId ?? this.campaignCoordinatorId,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
