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

import 'package:json_annotation/json_annotation.dart';

part 'wireguard_key_pair.g.dart';

/// Represents a WireGuard cryptographic key pair
@JsonSerializable()
class WireGuardKeyPair {
  /// Public key (base64 encoded, 44 characters)
  @JsonKey(name: 'pubkey')
  final String publicKey;
  
  /// Private key (base64 encoded, 44 characters, sensitive)
  @JsonKey(name: 'privkey')
  final String privateKey;

  WireGuardKeyPair({
    required this.publicKey,
    required this.privateKey,
  });

  /// Validate key format (base64, 44 characters)
  static bool isValidKey(String key) {
    // Trim whitespace before validation
    final trimmedKey = key.trim();
    if (trimmedKey.length != 44) return false;
    // Base64 pattern with optional padding
    final base64Pattern = RegExp(r'^[A-Za-z0-9+/]{43}=$');
    return base64Pattern.hasMatch(trimmedKey);
  }
  
  /// Check if public key is valid
  bool get isPublicKeyValid => isValidKey(publicKey);
  
  /// Check if private key is valid
  bool get isPrivateKeyValid => isValidKey(privateKey);
  
  /// Check if both keys are valid
  bool get isValid => isPublicKeyValid && isPrivateKeyValid;

  factory WireGuardKeyPair.fromJson(Map<String, dynamic> json) =>
      _$WireGuardKeyPairFromJson(json);

  Map<String, dynamic> toJson() => _$WireGuardKeyPairToJson(this);

  @override
  String toString() => 'WireGuardKeyPair(publicKey: ${publicKey.substring(0, 8)}...)';
}


