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
import '../models/wireguard_client.dart';
import '../services/opnsense_api_service.dart';

/// Form screen for creating/editing WireGuard clients
class WireGuardClientFormScreen extends StatefulWidget {
  final WireGuardClient? client;

  const WireGuardClientFormScreen({super.key, this.client});

  bool get isEditing => client != null;

  @override
  State<WireGuardClientFormScreen> createState() => _WireGuardClientFormScreenState();
}

class _WireGuardClientFormScreenState extends State<WireGuardClientFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _serverAddressController = TextEditingController();
  final _serverPortController = TextEditingController();
  final _serverPublicKeyController = TextEditingController();
  final _publicKeyController = TextEditingController();
  final _privateKeyController = TextEditingController();
  final _keepaliveController = TextEditingController();
  final _pskController = TextEditingController();

  List<String> _tunnelAddresses = [];
  bool _enabled = true;
  bool _isLoading = false;
  bool _isGeneratingKeys = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      _loadClientData();
    } else {
      _serverPortController.text = '51820';
      _keepaliveController.text = '25';
    }
  }

  void _loadClientData() {
    final client = widget.client!;
    _nameController.text = client.name;
    _serverAddressController.text = client.serveraddress;
    _serverPortController.text = client.serverport;
    _serverPublicKeyController.text = client.serverpubkey;
    _publicKeyController.text = client.pubkey;
    _privateKeyController.text = client.privkey;
    _tunnelAddresses = List.from(client.tunnelAddressList);
    _enabled = client.isEnabled;
    if (client.keepaliveInterval != null) {
      _keepaliveController.text = client.keepaliveInterval.toString();
    }
    if (client.hasPresharedKey) {
      _pskController.text = client.psk;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _serverAddressController.dispose();
    _serverPortController.dispose();
    _serverPublicKeyController.dispose();
    _publicKeyController.dispose();
    _privateKeyController.dispose();
    _keepaliveController.dispose();
    _pskController.dispose();
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

  Future<void> _saveClient() async {
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

      final request = WireGuardClientRequest(
        name: _nameController.text.trim(),
        pubkey: _publicKeyController.text.trim(),
        privkey: _privateKeyController.text.trim(),
        tunneladdress: _tunnelAddresses.join(','),
        serveraddress: _serverAddressController.text.trim(),
        serverport: _serverPortController.text.trim(),
        serverpubkey: _serverPublicKeyController.text.trim(),
        enabled: _enabled ? '1' : '0',
        keepalive: _keepaliveController.text.trim(),
        psk: _pskController.text.trim(),
      );

      if (widget.isEditing) {
        await apiService.updateWireGuardClient(widget.client!.uuid, request);
      } else {
        await apiService.createWireGuardClient(request);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.isEditing ? 'Client updated successfully' : 'Client created successfully',
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
            content: Text('Failed to save client: ${e.toString()}'),
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
              hintText: '10.10.10.2/24',
              helperText: 'Example: 10.10.10.2/24 or fd00::2/64',
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

  String? _validateKeepalive(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    final keepalive = int.tryParse(value);
    if (keepalive == null || keepalive < 0 || keepalive > 65535) {
      return 'Keepalive must be between 0 and 65535';
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

  String? _validateServerAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Server address is required';
    }
    // Allow IP addresses or hostnames
    if (_isValidIP(value) || _isValidIPv6(value)) {
      return null;
    }
    // Basic hostname validation
    final hostnamePattern = RegExp(r'^[a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?(\.[a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?)*$');
    if (hostnamePattern.hasMatch(value)) {
      return null;
    }
    return 'Invalid server address';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit WireGuard Client' : 'New WireGuard Client'),
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
                hintText: 'My WireGuard Client',
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

            // Server Address
            TextFormField(
              controller: _serverAddressController,
              decoration: const InputDecoration(
                labelText: 'Server Address',
                hintText: 'vpn.example.com or 203.0.113.1',
                prefixIcon: Icon(Icons.dns),
                helperText: 'IP address or hostname of the WireGuard server',
              ),
              validator: _validateServerAddress,
              enabled: !_isLoading,
            ),
            const SizedBox(height: 16),

            // Server Port
            TextFormField(
              controller: _serverPortController,
              decoration: const InputDecoration(
                labelText: 'Server Port',
                hintText: '51820',
                prefixIcon: Icon(Icons.settings_ethernet),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: _validatePort,
              enabled: !_isLoading,
            ),
            const SizedBox(height: 16),

            // Server Public Key
            TextFormField(
              controller: _serverPublicKeyController,
              decoration: const InputDecoration(
                labelText: 'Server Public Key',
                prefixIcon: Icon(Icons.vpn_key),
                helperText: 'Public key of the WireGuard server',
              ),
              validator: _validateWireGuardKey,
              enabled: !_isLoading,
              maxLines: 2,
            ),
            const SizedBox(height: 24),

            const Divider(),
            const Text(
              'Client Keys',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Public Key
            TextFormField(
              controller: _publicKeyController,
              decoration: const InputDecoration(
                labelText: 'Public Key',
                prefixIcon: Icon(Icons.vpn_key),
                helperText: 'Client public key',
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
                helperText: 'Client private key (keep secret)',
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

            const Divider(),
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

            // Keepalive
            TextFormField(
              controller: _keepaliveController,
              decoration: const InputDecoration(
                labelText: 'Keepalive Interval (Optional)',
                hintText: '25',
                prefixIcon: Icon(Icons.timer),
                helperText: 'Seconds (0-65535). Recommended: 25 for NAT traversal',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: _validateKeepalive,
              enabled: !_isLoading,
            ),
            const SizedBox(height: 16),

            // Pre-shared Key
            TextFormField(
              controller: _pskController,
              decoration: const InputDecoration(
                labelText: 'Pre-shared Key (Optional)',
                prefixIcon: Icon(Icons.security),
                helperText: 'Additional layer of symmetric encryption',
              ),
              obscureText: true,
              enabled: !_isLoading,
            ),
            const SizedBox(height: 16),

            // Enabled Switch
            SwitchListTile(
              title: const Text('Enabled'),
              subtitle: const Text('Client will be active when enabled'),
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
              onPressed: _isLoading ? null : _saveClient,
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
                      widget.isEditing ? 'Update Client' : 'Create Client',
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


