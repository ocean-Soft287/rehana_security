import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../data/model/manual_invitation_request.dart';
import '../../data/model/villa_model.dart';
import '../../data/repo/manual_invitation_repo.dart';

part 'manual_invitation_state.dart';

class ManualInvitationCubit extends Cubit<ManualInvitationState> {
  ManualInvitationCubit(this.manualInvitationRepo)
    : super(ManualInvitationInitial());

  final ManualInvitationRepo manualInvitationRepo;

  List<VillaModel> villas = [];

  /// آخر نص بحث اتبعت للسيرفر — بيتستخدم فى إعادة المحاولة
  String? villaSearchQuery;

  Timer? _searchDebounce;

  /// يميز آخر ريكوست عشان نتجاهل رد بحث قديم وصل متأخر
  int _searchRequestId = 0;

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }

  Future<void> getVillas({String? villaNumber}) async {
    _searchDebounce?.cancel();

    final search = villaNumber?.trim();
    villaSearchQuery = (search == null || search.isEmpty) ? null : search;

    final requestId = ++_searchRequestId;

    emit(VillasLoading());

    final response = await manualInvitationRepo.getVillas(
      villaNumber: villaSearchQuery,
    );

    // رد قديم وصل بعد ما اتبعت عملية بحث أحدث
    if (requestId != _searchRequestId || isClosed) return;

    response.fold((failure) => emit(VillasFailure(failure.message)), (data) {
      villas = data;
      emit(VillasSuccess(villas: data));
    });
  }

  /// بحث برقم الفيلا مع debounce حتى لا نرسل ريكوست مع كل حرف
  void searchVillas(String villaNumber) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      final trimmed = villaNumber.trim();
      final normalized = trimmed.isEmpty ? null : trimmed;

      if (normalized == villaSearchQuery) return;

      getVillas(villaNumber: normalized);
    });
  }

  Future<void> sendInvitation({
    required String villaNumber,
    String? visitorName,
    required String carPlateNumber,
    required DateTime visitTime,
    String? notes,
  }) async {
    emit(SendInvitationLoading());

    final response = await manualInvitationRepo.sendOneTimeInvitation(
      ManualInvitationRequest(
        villaNumber: villaNumber,
        visitorName: visitorName,
        carPlateNumber: carPlateNumber,
        visitTime: visitTime,
        notes: notes,
      ),
    );

    response.fold(
      (failure) => emit(SendInvitationFailure(failure.message)),
      (message) => emit(SendInvitationSuccess(message)),
    );
  }
}
