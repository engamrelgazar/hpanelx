import 'package:hpanelx/src/modules/vms/domain/repositories/vm_repository.dart';

class RebootVirtualMachineUseCase {
  final VmRepository repository;

  RebootVirtualMachineUseCase({required this.repository});

  Future<bool> execute(int id) async {
    return await repository.rebootVirtualMachine(id);
  }
}

class ShutdownVirtualMachineUseCase {
  final VmRepository repository;

  ShutdownVirtualMachineUseCase({required this.repository});

  Future<bool> execute(int id) async {
    return await repository.shutdownVirtualMachine(id);
  }
}

class StartVirtualMachineUseCase {
  final VmRepository repository;

  StartVirtualMachineUseCase({required this.repository});

  Future<bool> execute(int id) async {
    return await repository.startVirtualMachine(id);
  }
}
