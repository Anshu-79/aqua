import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';

@freezed
abstract class Profile with _$Profile {
  const factory Profile({
    String? name,
    String? email,
    int? currentPage,
    String? sex,
    DateTime? dob,
    int? height,
    int? weight,
  }) = _Profile;
}

extension ProfileExtension on Profile {

  Profile incrementPage() {
    return copyWith(currentPage: (currentPage ?? 0) + 1);
  }

  Profile decrementPage() {
    return copyWith(currentPage: (currentPage ?? 0) - 1);
  }
}
