import 'package:hpanelx/src/modules/vms/data/models/vm_model.dart';
import 'package:hpanelx/src/modules/vms/domain/repositories/vm_repository.dart';

class GetVirtualMachineByIdUseCase {
  final VmRepository repository;

  GetVirtualMachineByIdUseCase({required this.repository});

  Future<VmModel> execute(int id) async {
    return await repository.getVirtualMachineById(id);
  }
}
