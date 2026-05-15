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
import '../../models/wireguard_peer.dart';

/// Dialog for selecting WireGuard peers
class PeerSelectorDialog extends StatefulWidget {
  final List<WireGuardPeer> availablePeers;
  final List<String> selectedPeerUuids;

  const PeerSelectorDialog({
    super.key,
    required this.availablePeers,
    required this.selectedPeerUuids,
  });

  static Future<List<String>?> show({
    required BuildContext context,
    required List<WireGuardPeer> availablePeers,
    required List<String> selectedPeerUuids,
  }) async {
    return showDialog<List<String>>(
      context: context,
      builder: (context) => PeerSelectorDialog(
        availablePeers: availablePeers,
        selectedPeerUuids: List.from(selectedPeerUuids),
      ),
    );
  }

  @override
  State<PeerSelectorDialog> createState() => _PeerSelectorDialogState();
}

class _PeerSelectorDialogState extends State<PeerSelectorDialog> {
  late List<String> _selectedUuids;

  @override
  void initState() {
    super.initState();
    _selectedUuids = List.from(widget.selectedPeerUuids);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Peers'),
      content: SizedBox(
        width: double.maxFinite,
        child: widget.availablePeers.isEmpty
            ? const Center(child: Text('No peers available'))
            : ListView.builder(
                shrinkWrap: true,
                itemCount: widget.availablePeers.length,
                itemBuilder: (context, index) {
                  final peer = widget.availablePeers[index];
                  final isSelected = _selectedUuids.contains(peer.uuid);
                  
                  return CheckboxListTile(
                    title: Text(peer.name),
                    subtitle: Text('${peer.pubkey.substring(0, 20)}...'),
                    value: isSelected,
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          _selectedUuids.add(peer.uuid);
                        } else {
                          _selectedUuids.remove(peer.uuid);
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
          onPressed: () => Navigator.of(context).pop(_selectedUuids),
          child: const Text('Done'),
        ),
      ],
    );
  }
}

// Made with Bob
