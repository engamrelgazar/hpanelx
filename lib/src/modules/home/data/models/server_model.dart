class ServerModel {
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
  final List<IpAddress> ipv4;
  final List<IpAddress> ipv6;
  final ServerTemplate template;
  final String createdAt;

  ServerModel({
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

  factory ServerModel.fromJson(Map<String, dynamic> json) {
    return ServerModel(
      id: json['id'],
      firewallGroupId: json['firewall_group_id'],
      subscriptionId: json['subscription_id'],
      plan: json['plan'],
      hostname: json['hostname'],
      state: json['state'],
      actionsLock: json['actions_lock'],
      cpus: json['cpus'],
      memory: json['memory'],
      disk: json['disk'],
      bandwidth: json['bandwidth'],
      ns1: json['ns1'],
      ns2: json['ns2'],
      ipv4: (json['ipv4'] as List).map((ip) => IpAddress.fromJson(ip)).toList(),
      ipv6: (json['ipv6'] as List).map((ip) => IpAddress.fromJson(ip)).toList(),
      template: ServerTemplate.fromJson(json['template']),
      createdAt: json['created_at'],
    );
  }

  bool get isActive => state == 'running';
}

class IpAddress {
  final int id;
  final String address;
  final String ptr;

  IpAddress({required this.id, required this.address, required this.ptr});

  factory IpAddress.fromJson(Map<String, dynamic> json) {
    return IpAddress(
      id: json['id'],
      address: json['address'],
      ptr: json['ptr'],
    );
  }
}

class ServerTemplate {
  final int id;
  final String name;
  final String description;
  final String documentation;

  ServerTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.documentation,
  });

  factory ServerTemplate.fromJson(Map<String, dynamic> json) {
    return ServerTemplate(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      documentation: json['documentation'] ?? '',
    );
  }
}
