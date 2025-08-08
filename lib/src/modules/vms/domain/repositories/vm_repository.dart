import 'package:hpanelx/src/modules/vms/data/models/vm_model.dart';

abstract class VmRepository {
  Future<List<VmModel>> getVirtualMachines();

  Future<VmModel> getVirtualMachineById(int id);

  Future<bool> rebootVirtualMachine(int id);

  Future<bool> shutdownVirtualMachine(int id);

  Future<bool> startVirtualMachine(int id);
}
