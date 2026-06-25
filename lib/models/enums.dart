enum UserRole {
  campaignCoordinator,
  brigadeCoordinator,
  vaccinator;

  String get displayName {
    switch (this) {
      case UserRole.campaignCoordinator:
        return 'Coordinador de Campaña';
      case UserRole.brigadeCoordinator:
        return 'Coordinador de Brigada';
      case UserRole.vaccinator:
        return 'Vacunador';
    }
  }

  String get value {
    switch (this) {
      case UserRole.campaignCoordinator:
        return 'campaign_coordinator';
      case UserRole.brigadeCoordinator:
        return 'brigade_coordinator';
      case UserRole.vaccinator:
        return 'vaccinator';
    }
  }

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (e) => e.value == value,
      orElse: () => UserRole.vaccinator,
    );
  }
}

enum PetType {
  dog,
  cat;

  String get displayName {
    switch (this) {
      case PetType.dog:
        return 'Perro';
      case PetType.cat:
        return 'Gato';
    }
  }

  String get value {
    switch (this) {
      case PetType.dog:
        return 'dog';
      case PetType.cat:
        return 'cat';
    }
  }

  static PetType fromString(String value) {
    return PetType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => PetType.dog,
    );
  }
}

enum SyncStatus {
  pending,
  synced,
  error;

  String get value {
    switch (this) {
      case SyncStatus.pending:
        return 'pending';
      case SyncStatus.synced:
        return 'synced';
      case SyncStatus.error:
        return 'error';
    }
  }

  static SyncStatus fromString(String value) {
    return SyncStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => SyncStatus.pending,
    );
  }
}

enum Gender {
  male,
  female;

  String get displayName {
    switch (this) {
      case Gender.male:
        return 'Macho';
      case Gender.female:
        return 'Hembra';
    }
  }

  String get value {
    switch (this) {
      case Gender.male:
        return 'male';
      case Gender.female:
        return 'female';
    }
  }

  static Gender fromString(String value) {
    return Gender.values.firstWhere(
      (e) => e.value == value,
      orElse: () => Gender.male,
    );
  }
}
