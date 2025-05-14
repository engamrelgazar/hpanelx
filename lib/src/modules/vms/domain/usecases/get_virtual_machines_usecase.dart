import 'package:hpanelx/src/modules/vms/data/models/vm_model.dart';
import 'package:hpanelx/src/modules/vms/domain/repositories/vm_repository.dart';

class GetVirtualMachinesUseCase {
  final VmRepository repository;

  GetVirtualMachinesUseCase({required this.repository});

  Future<List<VmModel>> execute() async {
    return await repository.getVirtualMachines();
  }
}
