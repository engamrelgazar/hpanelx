import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hpanelx/src/modules/vms/data/models/vm_model.dart';
import 'package:hpanelx/src/modules/vms/domain/usecases/get_virtual_machines_usecase.dart';
import 'package:hpanelx/src/modules/vms/domain/usecases/get_virtual_machine_by_id_usecase.dart';
import 'package:hpanelx/src/modules/vms/domain/usecases/vm_action_usecases.dart';

abstract class VmsState extends Equatable {
  const VmsState();

  @override
  List<Object?> get props => [];
}

class VmsInitial extends VmsState {}

class VmsLoading extends VmsState {}

class VmsLoaded extends VmsState {
  final List<VmModel> vms;

  const VmsLoaded(this.vms);

  @override
  List<Object?> get props => [vms];
}

class VmDetailLoaded extends VmsState {
  final VmModel vm;

  const VmDetailLoaded(this.vm);

  @override
  List<Object?> get props => [vm];
}

class VmActionInProgress extends VmsState {
  final int vmId;
  final String action;

  const VmActionInProgress(this.vmId, this.action);

  @override
  List<Object?> get props => [vmId, action];
}

class VmActionSuccess extends VmsState {
  final int vmId;
  final String action;

  const VmActionSuccess(this.vmId, this.action);

  @override
  List<Object?> get props => [vmId, action];
}

class VmsError extends VmsState {
  final String message;

  const VmsError(this.message);

  @override
  List<Object?> get props => [message];
}

class VmsCubit extends Cubit<VmsState> {
  final GetVirtualMachinesUseCase getVirtualMachinesUseCase;
  final GetVirtualMachineByIdUseCase getVirtualMachineByIdUseCase;
  final RebootVirtualMachineUseCase rebootVirtualMachineUseCase;
  final ShutdownVirtualMachineUseCase shutdownVirtualMachineUseCase;
  final StartVirtualMachineUseCase startVirtualMachineUseCase;

  VmsCubit({
    required this.getVirtualMachinesUseCase,
    required this.getVirtualMachineByIdUseCase,
    required this.rebootVirtualMachineUseCase,
    required this.shutdownVirtualMachineUseCase,
    required this.startVirtualMachineUseCase,
  }) : super(VmsInitial());

  Future<void> getVirtualMachines() async {
    emit(VmsLoading());

    try {
      final vms = await getVirtualMachinesUseCase.execute();
      emit(VmsLoaded(vms));
    } catch (e) {
      emit(VmsError(e.toString()));
    }
  }

  Future<void> getVirtualMachineById(int id) async {
    emit(VmsLoading());

    try {
      final vm = await getVirtualMachineByIdUseCase.execute(id);
      emit(VmDetailLoaded(vm));
    } catch (e) {
      emit(VmsError(e.toString()));
    }
  }

  Future<void> rebootVirtualMachine(int id) async {
    emit(VmActionInProgress(id, 'reboot'));

    try {
      await rebootVirtualMachineUseCase.execute(id);
      emit(VmActionSuccess(id, 'reboot'));
      getVirtualMachineById(id);
    } catch (e) {
      emit(VmsError(e.toString()));
    }
  }

  Future<void> shutdownVirtualMachine(int id) async {
    emit(VmActionInProgress(id, 'shutdown'));

    try {
      await shutdownVirtualMachineUseCase.execute(id);
      emit(VmActionSuccess(id, 'shutdown'));
      getVirtualMachineById(id);
    } catch (e) {
      emit(VmsError(e.toString()));
    }
  }

  Future<void> startVirtualMachine(int id) async {
    emit(VmActionInProgress(id, 'start'));

    try {
      await startVirtualMachineUseCase.execute(id);
      emit(VmActionSuccess(id, 'start'));
      getVirtualMachineById(id);
    } catch (e) {
      emit(VmsError(e.toString()));
    }
  }
}
