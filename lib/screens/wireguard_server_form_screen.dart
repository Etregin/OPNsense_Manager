/*
 * OPNsense Manager - Flutter application for managing OPNsense firewalls
 * Copyright (C) 2026 OPNsense Manager
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/wireguard_server.dart';
import '../models/wireguard_peer.dart';
import '../services/opnsense_api_service.dart';

/// Form screen for creating/editing WireGuard servers
class WireGuardServerFormScreen extends StatefulWidget {
  final WireGuardServer? server;

  const WireGuardServerFormScreen({super.key, this.server});

  bool get isEditing => server != null;

  @override
  State<WireGuardServerFormScreen> createState() => _WireGuardServerFormScreenState();
}

class _WireGuardServerFormScreenState extends State<WireGuardServerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _portController = TextEditingController();
  final _publicKeyController = TextEditingController();
  final _privateKeyController = TextEditingController();
  final _mtuController = TextEditingController();
  final _gatewayController = TextEditingController();

  List<String> _tunnelAddresses = [];
  List<String> _dnsServers = [];
  List<String> _selectedPeerUuids = [];
  List<WireGuardPeer> _availablePeers = [];
  bool _enabled = true;
  bool _disableRoutes = false;
  bool _isLoading = false;
  bool _isGeneratingKeys = false;
  bool _loadingPeers = true;

  @override
  void initState() {
    super.initState();
    _loadPeers();
    if (widget.isEditing) {
      _loadServerData();
    } else {
      _portController.text = '51820';
    }
  }

  Future<void> _loadPeers() async {
    try {
      final apiService = context.read<OPNsenseApiService>();
      final peers = await apiService.getWireGuardPeers();

      if (mounted) {
        setState(() {
          _availablePeers = peers;
          _loadingPeers = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loadingPeers = false;
        });
      }
    }
  }

  void _loadServerData() {
    final server = widget.server!;
    _nameController.text = server.name;
    _portController.text = server.port;
    _publicKeyController.text = server.pubkey;
    _privateKeyController.text = server.privkey;
    _tunnelAddresses = List.from(server.tunnelAddressList);
    _dnsServers = List.from(server.dnsList);
    _selectedPeerUuids = List.from(server.peerUuidList);
    _enabled = server.isEnabled;
    _disableRoutes = server.hasRoutesDisabled;
    if (server.mtuValue != null) {
      _mtuController.text = server.mtuValue.toString();
    }
    if (server.gateway.isNotEmpty) {
      _gatewayController.text = server.gateway;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _portController.dispose();
    _publicKeyController.dispose();
    _privateKeyController.dispose();
    _mtuController.dispose();
    _gatewayController.dispose();
    super.dispose();
  }

  Future<void> _generateKeys() async {
    setState(() {
      _isGeneratingKeys = true;
    });

    try {
      final apiService = context.read<OPNsenseApiService>();
      final keyPair = await apiService.generateWireGuardKeyPair();

      if (mounted) {
        setState(() {
          _publicKeyController.text = keyPair.publicKey;
          _privateKeyController.text = keyPair.privateKey;
          _isGeneratingKeys = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Keys generated successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isGeneratingKeys = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate keys: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _saveServer() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_tunnelAddresses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('At least one tunnel address is required'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final apiService = context.read<OPNsenseApiService>();

      final request = WireGuardServerRequest(
        name: _nameController.text.trim(),
        pubkey: _publicKeyController.text.trim(),
        privkey: _privateKeyController.text.trim(),
        port: _portController.text.trim(),
        tunneladdress: _tunnelAddresses.join(','),
        enabled: _enabled ? '1' : '0',
        peers: _selectedPeerUuids.join(','),
        disableroutes: _disableRoutes ? '1' : '0',
        gateway: _gatewayController.text.trim(),
        mtu: _mtuController.text.trim(),
        dns: _dnsServers.join(','),
      );

      if (widget.isEditing) {
        await apiService.updateWireGuardServer(widget.server!.uuid, request);
      } else {
        await apiService.createWireGuardServer(request);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.isEditing ? 'Server updated successfully' : 'Server created successfully',
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save server: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _addTunnelAddress() {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Add Tunnel Address'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Tunnel Address (CIDR)',
              hintText: '10.10.10.1/24',
              helperText: 'Example: 10.10.10.1/24 or fd00::1/64',
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final address = controller.text.trim();
                if (address.isNotEmpty && _isValidCIDR(address)) {
                  setState(() {
                    _tunnelAddresses.add(address);
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Invalid CIDR notation'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _addDnsServer() {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Add DNS Server'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'DNS Server IP',
              hintText: '8.8.8.8',
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final dns = controller.text.trim();
                if (dns.isNotEmpty && _isValidIP(dns)) {
                  setState(() {
                    _dnsServers.add(dns);
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Invalid IP address'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _selectPeers() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Select Peers'),
              content: SizedBox(
                width: double.maxFinite,
                child: _availablePeers.isEmpty
                    ? const Center(child: Text('No peers available'))
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: _availablePeers.length,
                        itemBuilder: (context, index) {
                          final peer = _availablePeers[index];
                          final isSelected = _selectedPeerUuids.contains(peer.uuid);
                          return CheckboxListTile(
                            title: Text(peer.name),
                            subtitle: Text('${peer.pubkey.substring(0, 20)}...'),
                            value: isSelected,
                            onChanged: (value) {
                              setDialogState(() {
                                if (value == true) {
                                  _selectedPeerUuids.add(peer.uuid);
                                } else {
                                  _selectedPeerUuids.remove(peer.uuid);
                                }
                              });
                            },
                          );
                        },
                      ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {});
                    Navigator.of(context).pop();
                  },
                  child: const Text('Done'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  bool _isValidCIDR(String cidr) {
    final parts = cidr.split('/');
    if (parts.length != 2) return false;

    final prefix = int.tryParse(parts[1]);
    if (prefix == null) return false;

    // Check for IPv4
    if (_isValidIP(parts[0])) {
      return prefix >= 0 && prefix <= 32;
    }

    // Check for IPv6
    if (_isValidIPv6(parts[0])) {
      return prefix >= 0 && prefix <= 128;
    }

    return false;
  }

  bool _isValidIP(String ip) {
    final parts = ip.split('.');
    if (parts.length != 4) return false;

    for (final part in parts) {
      final num = int.tryParse(part);
      if (num == null || num < 0 || num > 255) {
        return false;
      }
    }
    return true;
  }

  bool _isValidIPv6(String ip) {
    // Simplified IPv6 validation
    final ipv6Pattern = RegExp(r'^([0-9a-fA-F]{0,4}:){2,7}[0-9a-fA-F]{0,4}$');
    return ipv6Pattern.hasMatch(ip);
  }

  String? _validatePort(String? value) {
    if (value == null || value.isEmpty) {
      return 'Port is required';
    }
    final port = int.tryParse(value);
    if (port == null || port < 1 || port > 65535) {
      return 'Port must be between 1 and 65535';
    }
    return null;
  }

  String? _validateMTU(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    final mtu = int.tryParse(value);
    if (mtu == null || mtu < 576 || mtu > 9000) {
      return 'MTU must be between 576 and 9000';
    }
    return null;
  }

  String? _validateWireGuardKey(String? value) {
    if (value == null || value.isEmpty) {
      return 'Key is required';
    }
    if (value.length != 44) {
      return 'Invalid key length (must be 44 characters)';
    }
    // Basic base64 validation
    final base64Pattern = RegExp(r'^[A-Za-z0-9+/]+=*$');
    if (!base64Pattern.hasMatch(value)) {
      return 'Invalid key format (must be base64)';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit WireGuard Server' : 'New WireGuard Server'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'My WireGuard Server',
                prefixIcon: Icon(Icons.label),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Name is required';
                }
                return null;
              },
              enabled: !_isLoading,
            ),
            const SizedBox(height: 16),

            // Port
            TextFormField(
              controller: _portController,
              decoration: const InputDecoration(
                labelText: 'Port',
                hintText: '51820',
                prefixIcon: Icon(Icons.settings_ethernet),
                helperText: 'UDP port (default: 51820)',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: _validatePort,
              enabled: !_isLoading,
            ),
            const SizedBox(height: 16),

            // Public Key
            TextFormField(
              controller: _publicKeyController,
              decoration: const InputDecoration(
                labelText: 'Public Key',
                prefixIcon: Icon(Icons.vpn_key),
                helperText: 'Base64 encoded public key',
              ),
              validator: _validateWireGuardKey,
              enabled: !_isLoading && !_isGeneratingKeys,
              maxLines: 2,
            ),
            const SizedBox(height: 16),

            // Private Key
            TextFormField(
              controller: _privateKeyController,
              decoration: const InputDecoration(
                labelText: 'Private Key',
                prefixIcon: Icon(Icons.lock),
                helperText: 'Base64 encoded private key (keep secret)',
              ),
              validator: _validateWireGuardKey,
              enabled: !_isLoading && !_isGeneratingKeys,
              obscureText: true,
              maxLines: 1,
            ),
            const SizedBox(height: 8),

            // Generate Keys Button
            ElevatedButton.icon(
              onPressed: _isLoading || _isGeneratingKeys ? null : _generateKeys,
              icon: _isGeneratingKeys
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.refresh),
              label: Text(_isGeneratingKeys ? 'Generating...' : 'Generate Key Pair'),
            ),
            const SizedBox(height: 24),

            // Tunnel Addresses
            const Text(
              'Tunnel Addresses',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (_tunnelAddresses.isEmpty)
              const Text(
                'No tunnel addresses configured',
                style: TextStyle(color: Colors.grey),
              )
            else
              ..._tunnelAddresses.map((address) => Card(
                    child: ListTile(
                      title: Text(address),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: _isLoading
                            ? null
                            : () {
                                setState(() {
                                  _tunnelAddresses.remove(address);
                                });
                              },
                      ),
                    ),
                  )),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _isLoading ? null : _addTunnelAddress,
              icon: const Icon(Icons.add),
              label: const Text('Add Tunnel Address'),
            ),
            const SizedBox(height: 24),

            // MTU
            TextFormField(
              controller: _mtuController,
              decoration: const InputDecoration(
                labelText: 'MTU (Optional)',
                hintText: '1420',
                prefixIcon: Icon(Icons.settings),
                helperText: 'Maximum Transmission Unit (576-9000)',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: _validateMTU,
              enabled: !_isLoading,
            ),
            const SizedBox(height: 16),

            // DNS Servers
            const Text(
              'DNS Servers (Optional)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (_dnsServers.isEmpty)
              const Text(
                'No DNS servers configured',
                style: TextStyle(color: Colors.grey),
              )
            else
              ..._dnsServers.map((dns) => Card(
                    child: ListTile(
                      title: Text(dns),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: _isLoading
                            ? null
                            : () {
                                setState(() {
                                  _dnsServers.remove(dns);
                                });
                              },
                      ),
                    ),
                  )),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _isLoading ? null : _addDnsServer,
              icon: const Icon(Icons.add),
              label: const Text('Add DNS Server'),
            ),
            const SizedBox(height: 16),

            // Gateway
            TextFormField(
              controller: _gatewayController,
              decoration: const InputDecoration(
                labelText: 'Gateway (Optional)',
                hintText: '10.10.10.1',
                prefixIcon: Icon(Icons.router),
              ),
              enabled: !_isLoading,
            ),
            const SizedBox(height: 16),

            // Peers
            const Text(
              'Authorized Peers',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                title: Text('${_selectedPeerUuids.length} peer(s) selected'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: _isLoading || _loadingPeers ? null : _selectPeers,
              ),
            ),
            const SizedBox(height: 16),

            // Disable Routes Switch
            SwitchListTile(
              title: const Text('Disable Routes'),
              subtitle: const Text('Prevent automatic route installation'),
              value: _disableRoutes,
              onChanged: _isLoading
                  ? null
                  : (value) {
                      setState(() {
                        _disableRoutes = value;
                      });
                    },
            ),

            // Enabled Switch
            SwitchListTile(
              title: const Text('Enabled'),
              subtitle: const Text('Server will be active when enabled'),
              value: _enabled,
              onChanged: _isLoading
                  ? null
                  : (value) {
                      setState(() {
                        _enabled = value;
                      });
                    },
            ),
            const SizedBox(height: 24),

            // Save Button
            ElevatedButton(
              onPressed: _isLoading ? null : _saveServer,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      widget.isEditing ? 'Update Server' : 'Create Server',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}


