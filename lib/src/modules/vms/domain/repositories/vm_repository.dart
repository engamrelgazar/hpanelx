import 'package:hpanelx/src/modules/vms/data/models/vm_model.dart';

abstract class VmRepository {
  /// Get all virtual machines
  Future<List<VmModel>> getVirtualMachines();

  /// Get a specific virtual machine by ID
  Future<VmModel> getVirtualMachineById(int id);

  /// Reboot a specific virtual machine
  Future<bool> rebootVirtualMachine(int id);

  /// Shutdown a specific virtual machine
  Future<bool> shutdownVirtualMachine(int id);

  /// Start a specific virtual machine
  Future<bool> startVirtualMachine(int id);
}
