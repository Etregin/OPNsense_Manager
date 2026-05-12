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
import '../models/wireguard_peer.dart';
import '../services/opnsense_api_service.dart';

/// Form screen for creating/editing WireGuard peers
class WireGuardPeerFormScreen extends StatefulWidget {
  final WireGuardPeer? peer;

  const WireGuardPeerFormScreen({super.key, this.peer});

  bool get isEditing => peer != null;

  @override
  State<WireGuardPeerFormScreen> createState() => _WireGuardPeerFormScreenState();
}

class _WireGuardPeerFormScreenState extends State<WireGuardPeerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _publicKeyController = TextEditingController();
  final _endpointController = TextEditingController();
  final _keepaliveController = TextEditingController();
  final _pskController = TextEditingController();

  List<String> _tunnelAddresses = [];
  bool _enabled = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      _loadPeerData();
    }
  }

  void _loadPeerData() {
    final peer = widget.peer!;
    _nameController.text = peer.name;
    _publicKeyController.text = peer.pubkey;
    _tunnelAddresses = List.from(peer.tunnelAddressList);
    _enabled = peer.isEnabled;
    if (peer.hasEndpoint) {
      _endpointController.text = peer.endpoint;
    }
    if (peer.keepaliveInterval != null) {
      _keepaliveController.text = peer.keepaliveInterval.toString();
    }
    if (peer.hasPresharedKey) {
      _pskController.text = peer.psk;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _publicKeyController.dispose();
    _endpointController.dispose();
    _keepaliveController.dispose();
    _pskController.dispose();
    super.dispose();
  }

  Future<void> _savePeer() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_tunnelAddresses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('At least one allowed tunnel address is required'),
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

      final request = WireGuardPeerRequest(
        name: _nameController.text.trim(),
        pubkey: _publicKeyController.text.trim(),
        tunneladdress: _tunnelAddresses.join(','),
        enabled: _enabled ? '1' : '0',
        endpoint: _endpointController.text.trim(),
        keepalive: _keepaliveController.text.trim(),
        psk: _pskController.text.trim(),
      );

      if (widget.isEditing) {
        await apiService.updateWireGuardPeer(widget.peer!.uuid, request);
      } else {
        await apiService.createWireGuardPeer(request);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.isEditing ? 'Peer updated successfully' : 'Peer created successfully',
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
            content: Text('Failed to save peer: ${e.toString()}'),
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
          title: const Text('Add Allowed Tunnel Address'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Tunnel Address (CIDR)',
              hintText: '10.10.10.2/32',
              helperText: 'Example: 10.10.10.2/32 or fd00::2/128',
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

  String? _validateEndpoint(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    
    // Format: IP:port or hostname:port
    final parts = value.split(':');
    if (parts.length != 2) {
      return 'Format must be IP:port or hostname:port';
    }

    // Validate port
    final port = int.tryParse(parts[1]);
    if (port == null || port < 1 || port > 65535) {
      return 'Invalid port number';
    }

    // Validate IP or hostname
    final host = parts[0];
    if (!_isValidIP(host) && !_isValidIPv6(host) && !_isValidHostname(host)) {
      return 'Invalid IP address or hostname';
    }

    return null;
  }

  bool _isValidHostname(String hostname) {
    final hostnamePattern = RegExp(
      r'^[a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?(\.[a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?)*$'
    );
    return hostnamePattern.hasMatch(hostname);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit WireGuard Peer' : 'New WireGuard Peer'),
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
                hintText: 'Peer Name',
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

            // Public Key
            TextFormField(
              controller: _publicKeyController,
              decoration: const InputDecoration(
                labelText: 'Public Key',
                prefixIcon: Icon(Icons.vpn_key),
                helperText: 'Base64 encoded public key of the peer',
              ),
              validator: _validateWireGuardKey,
              enabled: !_isLoading,
              maxLines: 2,
            ),
            const SizedBox(height: 24),

            // Tunnel Addresses
            const Text(
              'Allowed Tunnel Addresses',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'IP addresses this peer is allowed to use',
              style: TextStyle(fontSize: 12, color: Colors.grey),
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
              label: const Text('Add Allowed Address'),
            ),
            const SizedBox(height: 24),

            // Endpoint
            TextFormField(
              controller: _endpointController,
              decoration: const InputDecoration(
                labelText: 'Endpoint (Optional)',
                hintText: '203.0.113.1:51820',
                prefixIcon: Icon(Icons.location_on),
                helperText: 'IP:port or hostname:port. Only needed if server initiates connection',
              ),
              validator: _validateEndpoint,
              enabled: !_isLoading,
            ),
            const SizedBox(height: 16),

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
              subtitle: const Text('Peer will be active when enabled'),
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

            // Help Card
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue[700]),
                        const SizedBox(width: 8),
                        Text(
                          'Peer Configuration',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• Allowed addresses define which IPs this peer can use\n'
                      '• Endpoint is only needed if the server initiates connections\n'
                      '• Keepalive helps maintain connections through NAT\n'
                      '• Pre-shared key adds post-quantum security',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[900],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Save Button
            ElevatedButton(
              onPressed: _isLoading ? null : _savePeer,
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
                      widget.isEditing ? 'Update Peer' : 'Create Peer',
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


