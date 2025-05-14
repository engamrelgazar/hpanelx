import 'package:hpanelx/src/core/api/api_client.dart';
import 'package:hpanelx/src/core/api/api_constants.dart';
import 'package:hpanelx/src/modules/vms/data/models/vm_model.dart';

abstract class VmRemoteDataSource {
  /// Get all virtual machines
  Future<List<VmModel>> getVirtualMachines();

  /// Get a specific virtual machine by ID
  Future<VmModel> getVirtualMachineById(int id);

  /// Reboot a specific virtual machine
  Future<dynamic> rebootVirtualMachine(int id);

  /// Shutdown a specific virtual machine
  Future<dynamic> shutdownVirtualMachine(int id);

  /// Start a specific virtual machine
  Future<dynamic> startVirtualMachine(int id);
}

class VmRemoteDataSourceImpl implements VmRemoteDataSource {
  final ApiClient apiClient;

  VmRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<VmModel>> getVirtualMachines() async {
    try {
      final response = await apiClient.get(ApiConstants.serversEndpoint);

      if (response != null) {
        final List<dynamic> vmsJson = response;
        return vmsJson.map((json) => VmModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load virtual machines: No data returned');
      }
    } catch (e) {
      throw Exception('Failed to load virtual machines from API: $e');
    }
  }

  @override
  Future<VmModel> getVirtualMachineById(int id) async {
    try {
      final response = await apiClient.get(
        '${ApiConstants.serversEndpoint}/$id',
      );

      if (response != null) {
        return VmModel.fromJson(response);
      } else {
        throw Exception('Failed to load virtual machine: No data returned');
      }
    } catch (e) {
      throw Exception('Failed to load virtual machine from API: $e');
    }
  }

  @override
  Future<dynamic> rebootVirtualMachine(int id) async {
    try {
      final response = await apiClient.post(
        '${ApiConstants.serversEndpoint}/$id/restart',
      );

      if (response == null) {
        throw Exception('Failed to reboot virtual machine: No data returned');
      }

      return response;
    } catch (e) {
      throw Exception('Failed to reboot virtual machine from API: $e');
    }
  }

  @override
  Future<dynamic> shutdownVirtualMachine(int id) async {
    try {
      final response = await apiClient.post(
        '${ApiConstants.serversEndpoint}/$id/stop',
      );

      if (response == null) {
        throw Exception(
          'Failed to shut down virtual machine: No data returned',
        );
      }

      return response;
    } catch (e) {
      throw Exception('Failed to shut down virtual machine from API: $e');
    }
  }

  @override
  Future<dynamic> startVirtualMachine(int id) async {
    try {
      final response = await apiClient.post(
        '${ApiConstants.serversEndpoint}/$id/start',
      );

      if (response == null) {
        throw Exception('Failed to start virtual machine: No data returned');
      }

      return response;
    } catch (e) {
      throw Exception('Failed to start virtual machine from API: $e');
    }
  }
}
