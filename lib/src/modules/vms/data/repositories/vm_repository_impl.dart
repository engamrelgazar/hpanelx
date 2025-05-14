import 'package:hpanelx/src/modules/vms/data/datasources/vm_remote_datasource.dart';
import 'package:hpanelx/src/modules/vms/data/models/vm_model.dart';
import 'package:hpanelx/src/modules/vms/domain/repositories/vm_repository.dart';

class VmRepositoryImpl implements VmRepository {
  final VmRemoteDataSource remoteDataSource;

  VmRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<VmModel>> getVirtualMachines() async {
    try {
      return await remoteDataSource.getVirtualMachines();
    } catch (e) {
      throw Exception('Failed to load virtual machines: $e');
    }
  }

  @override
  Future<VmModel> getVirtualMachineById(int id) async {
    try {
      return await remoteDataSource.getVirtualMachineById(id);
    } catch (e) {
      throw Exception('Failed to load virtual machine: $e');
    }
  }

  @override
  Future<bool> rebootVirtualMachine(int id) async {
    try {
      final response = await remoteDataSource.rebootVirtualMachine(id);
      return response != null;
    } catch (e) {
      throw Exception('Failed to reboot virtual machine: $e');
    }
  }

  @override
  Future<bool> shutdownVirtualMachine(int id) async {
    try {
      final response = await remoteDataSource.shutdownVirtualMachine(id);
      return response != null;
    } catch (e) {
      throw Exception('Failed to shut down virtual machine: $e');
    }
  }

  @override
  Future<bool> startVirtualMachine(int id) async {
    try {
      final response = await remoteDataSource.startVirtualMachine(id);
      return response != null;
    } catch (e) {
      throw Exception('Failed to start virtual machine: $e');
    }
  }
}
