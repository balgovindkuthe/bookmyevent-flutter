import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/scan_qrcode_usecase.dart';
import 'checkin_event.dart';
import 'checkin_state.dart';

class CheckInBloc extends Bloc<CheckInEvent, CheckInState> {
  final ScanQrCodeUseCase scanQrCodeUseCase;

  CheckInBloc({required this.scanQrCodeUseCase}) : super(CheckInInitial()) {
    on<ScanQrCodeRequested>(_onScanQrCodeRequested);
  }

  Future<void> _onScanQrCodeRequested(ScanQrCodeRequested event, Emitter<CheckInState> emit) async {
    emit(CheckInLoading());
    final result = await scanQrCodeUseCase(QrCodeParams(qrCodeUuid: event.qrCodeUuid));
    
    result.fold(
      (failure) => emit(CheckInError(failure.message)),
      (checkInEntity) => emit(CheckInSuccess(checkInEntity)),
    );
  }
}
