import 'package:hpanelx/src/modules/vms/data/models/ip_model.dart';
import 'package:hpanelx/src/modules/vms/data/models/template_model.dart';

class VmModel {
  final int id;
  final String? firewallGroupId;
  final String subscriptionId;
  final String plan;
  final String hostname;
  final String state;
  final String actionsLock;
  final int cpus;
  final int memory;
  final int disk;
  final int bandwidth;
  final String ns1;
  final String ns2;
  final List<IpModel> ipv4;
  final List<IpModel> ipv6;
  final TemplateModel template;
  final String createdAt;

  VmModel({
    required this.id,
    this.firewallGroupId,
    required this.subscriptionId,
    required this.plan,
    required this.hostname,
    required this.state,
    required this.actionsLock,
    required this.cpus,
    required this.memory,
    required this.disk,
    required this.bandwidth,
    required this.ns1,
    required this.ns2,
    required this.ipv4,
    required this.ipv6,
    required this.template,
    required this.createdAt,
  });

  factory VmModel.fromJson(Map<String, dynamic> json) {
    List<IpModel> ipv4List = [];
    if (json['ipv4'] != null) {
      for (var ip in json['ipv4']) {
        ipv4List.add(IpModel.fromJson(ip));
      }
    }

    List<IpModel> ipv6List = [];
    if (json['ipv6'] != null) {
      for (var ip in json['ipv6']) {
        ipv6List.add(IpModel.fromJson(ip));
      }
    }

    return VmModel(
      id: json['id'] ?? 0,
      firewallGroupId: json['firewall_group_id'],
      subscriptionId: json['subscription_id'] ?? '',
      plan: json['plan'] ?? '',
      hostname: json['hostname'] ?? '',
      state: json['state'] ?? '',
      actionsLock: json['actions_lock'] ?? '',
      cpus: json['cpus'] ?? 0,
      memory: json['memory'] ?? 0,
      disk: json['disk'] ?? 0,
      bandwidth: json['bandwidth'] ?? 0,
      ns1: json['ns1'] ?? '',
      ns2: json['ns2'] ?? '',
      ipv4: ipv4List,
      ipv6: ipv6List,
      template: json['template'] != null
          ? TemplateModel.fromJson(json['template'])
          : TemplateModel(id: 0, name: '', description: ''),
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firewall_group_id': firewallGroupId,
      'subscription_id': subscriptionId,
      'plan': plan,
      'hostname': hostname,
      'state': state,
      'actions_lock': actionsLock,
      'cpus': cpus,
      'memory': memory,
      'disk': disk,
      'bandwidth': bandwidth,
      'ns1': ns1,
      'ns2': ns2,
      'ipv4': ipv4.map((ip) => ip.toJson()).toList(),
      'ipv6': ipv6.map((ip) => ip.toJson()).toList(),
      'template': template.toJson(),
      'created_at': createdAt,
    };
  }
}
