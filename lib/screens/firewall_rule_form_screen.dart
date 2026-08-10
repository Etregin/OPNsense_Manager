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
import 'package:provider/provider.dart';
import '../models/firewall_rule.dart';
import '../models/firewall_form_options.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../utils/snackbar_helper.dart';
import '../utils/validators.dart';
import '../l10n/app_localizations.dart';
import '../viewmodels/firewall_rule_form_view_model.dart';
import '../widgets/common/loading_overlay.dart';

// ──────────────────────────────────────────────────────────────────────────────
// ICMP type options — full set from OPNsense API
// ──────────────────────────────────────────────────────────────────────────────
const _kIcmpTypes = {
  '':           'any',
  // Common
  'echoreq':    'Echo Request',
  'echorep':    'Echo Reply',
  'unreach':    'Destination Unreachable',
  'redir':      'Redirect',
  'routeradv':  'Router Advertisement',
  'routersol':  'Router Solicitation',
  'timex':      'Time Exceeded',
  'paramprob':  'Parameter Problem',
  'timereq':    'Timestamp',
  'timerep':    'Timestamp Reply',
  'photuris':   'Photuris',
  // Deprecated
  'squench':    'Source Quench',
  'althost':    'Alternate Host Address',
  'inforeq':    'Information Request',
  'inforep':    'Information Reply',
  'maskreq':    'Address Mask Request',
  'maskrep':    'Address Mask Reply',
  'trace':      'Traceroute',
  'dataconv':   'Data conversion problem',
  'mobredir':   'Mobile host redirection',
  'ipv6-where': 'IPv6 where-are-you',
  'ipv6-here':  'IPv6 i-am-here',
  'mobregreq':  'Mobile registration request',
  'mobregrep':  'Mobile registration reply',
  'skip':       'SKIP',
};

const _kIcmp6Types = {
  '':    'any',
  '1':   'Destination unreachable',
  '2':   'Packet too big',
  '3':   'Time exceeded',
  '4':   'Invalid IPv6 header',
  '128': 'Echo service request',
  '129': 'Echo service reply',
  '130': 'Multicast Listener Query',
  '131': 'Multicast listener report',
  '132': 'Multicast listener done',
  '133': 'Router solicitation',
  '134': 'Router advertisement',
  '135': 'Neighbor solicitation',
  '136': 'Neighbor advertisement',
  '137': 'Shorter route exists',
  '138': 'Route renumbering',
  '139': 'ICMP Node Information Query',
  '140': 'Node information reply',
  '200': 'mtrace response',
  '201': 'mtrace messages',
};

// ──────────────────────────────────────────────────────────────────────────────
// Protocol options — full set from OPNsense API
// ──────────────────────────────────────────────────────────────────────────────
const _kProtocols = <String, String>{
  'any':             'any',
  'TCP':             'TCP',
  'UDP':             'UDP',
  'TCP/UDP':         'TCP/UDP',
  'ICMP':            'ICMP',
  'ESP':             'ESP',
  'AH':              'AH',
  'GRE':             'GRE',
  'IGMP':            'IGMP',
  'PIM':             'PIM',
  'OSPF':            'OSPF',
  '3PC':             '3PC',
  'A/N':             'A/N',
  'ARGUS':           'ARGUS',
  'ARIS':            'ARIS',
  'AX.25':           'AX.25',
  'BBN-RCC':         'BBN-RCC',
  'BNA':             'BNA',
  'BR-SAT-MON':      'BR-SAT-MON',
  'CARP':            'CARP',
  'CBT':             'CBT',
  'CFTP':            'CFTP',
  'CHAOS':           'CHAOS',
  'COMPAQ-PEER':     'COMPAQ-PEER',
  'CPHB':            'CPHB',
  'CPNX':            'CPNX',
  'CRTP':            'CRTP',
  'CRUDP':           'CRUDP',
  'DCCP':            'DCCP',
  'DCN':             'DCN',
  'DDP':             'DDP',
  'DDX':             'DDX',
  'DGP':             'DGP',
  'DIVERT':          'DIVERT',
  'DSR':             'DSR',
  'EGP':             'EGP',
  'EIGRP':           'EIGRP',
  'EMCON':           'EMCON',
  'ENCAP':           'ENCAP',
  'ETHERIP':         'ETHERIP',
  'FC':              'FC',
  'GGP':             'GGP',
  'GMTP':            'GMTP',
  'HIP':             'HIP',
  'HMP':             'HMP',
  'I-NLSP':          'I-NLSP',
  'IATP':            'IATP',
  'IDPR':            'IDPR',
  'IDPR-CMTP':       'IDPR-CMTP',
  'IDRP':            'IDRP',
  'IFMP':            'IFMP',
  'IGP':             'IGP',
  'IL':              'IL',
  'IPCOMP':          'IPCOMP',
  'IPCV':            'IPCV',
  'IPENCAP':         'IPENCAP',
  'IPIP':            'IPIP',
  'IPPC':            'IPPC',
  'IPV6':            'IPV6',
  'IPV6-ICMP':       'IPV6-ICMP',
  'IPX-IN-IP':       'IPX-IN-IP',
  'IRTP':            'IRTP',
  'ISIS':            'ISIS',
  'ISO-IP':          'ISO-IP',
  'ISO-TP4':         'ISO-TP4',
  'KRYPTOLAN':       'KRYPTOLAN',
  'L2TP':            'L2TP',
  'LARP':            'LARP',
  'LEAF-1':          'LEAF-1',
  'LEAF-2':          'LEAF-2',
  'MANET':           'MANET',
  'MERIT-INP':       'MERIT-INP',
  'MFE-NSP':         'MFE-NSP',
  'MICP':            'MICP',
  'MOBILE':          'MOBILE',
  'MPLS-IN-IP':      'MPLS-IN-IP',
  'MTP':             'MTP',
  'MUX':             'MUX',
  'NARP':            'NARP',
  'NETBLT':          'NETBLT',
  'NSFNET-IGP':      'NSFNET-IGP',
  'NVP':             'NVP',
  'PFSYNC':          'PFSYNC',
  'PGM':             'PGM',
  'PIPE':            'PIPE',
  'PNNI':            'PNNI',
  'PRM':             'PRM',
  'PTP':             'PTP',
  'PUP':             'PUP',
  'PVP':             'PVP',
  'QNX':             'QNX',
  'RDP':             'RDP',
  'ROHC':            'ROHC',
  'RSVP':            'RSVP',
  'RSVP-E2E-IGNORE': 'RSVP-E2E-IGNORE',
  'RVD':             'RVD',
  'SAT-EXPAK':       'SAT-EXPAK',
  'SAT-MON':         'SAT-MON',
  'SCC-SP':          'SCC-SP',
  'SCPS':            'SCPS',
  'SCTP':            'SCTP',
  'SDRP':            'SDRP',
  'SECURE-VMTP':     'SECURE-VMTP',
  'SHIM6':           'SHIM6',
  'SKIP':            'SKIP',
  'SM':              'SM',
  'SMP':             'SMP',
  'SNP':             'SNP',
  'SPRITE-RPC':      'SPRITE-RPC',
  'SPS':             'SPS',
  'SRP':             'SRP',
  'ST2':             'ST2',
  'STP':             'STP',
  'SUN-ND':          'SUN-ND',
  'SWIPE':           'SWIPE',
  'TCF':             'TCF',
  'TLSP':            'TLSP',
  'TP++':            'TP++',
  'TRUNK-1':         'TRUNK-1',
  'TRUNK-2':         'TRUNK-2',
  'TTP':             'TTP',
  'UDPLITE':         'UDPLITE',
  'UTI':             'UTI',
  'VINES':           'VINES',
  'VISA':            'VISA',
  'VMTP':            'VMTP',
  'WB-EXPAK':        'WB-EXPAK',
  'WB-MON':          'WB-MON',
  'WESP':            'WESP',
  'WSN':             'WSN',
  'XNET':            'XNET',
  'XNS-IDP':         'XNS-IDP',
  'XTP':             'XTP',
};

const _kTcpFlagNames = ['syn', 'ack', 'fin', 'rst', 'psh', 'urg', 'ece', 'cwr'];

// ──────────────────────────────────────────────────────────────────────────────

/// Form screen for creating or editing firewall rules
class FirewallRuleFormScreen extends StatefulWidget {
  final FirewallRule? rule;

  const FirewallRuleFormScreen({super.key, this.rule});

  bool get isEditing => rule != null;

  @override
  State<FirewallRuleFormScreen> createState() => _FirewallRuleFormScreenState();
}

class _FirewallRuleFormScreenState extends State<FirewallRuleFormScreen> {
  late FirewallRuleFormViewModel _viewModel;
  final _formKey = GlobalKey<FormState>();

  // ── Text controllers ────────────────────────────────────────────────────────
  final _descriptionController = TextEditingController();
  final _sourceController = TextEditingController();
  final _sourcePortController = TextEditingController();
  final _destinationController = TextEditingController();
  final _destinationPortController = TextEditingController();
  final _sequenceController = TextEditingController();
  final _statTimeoutController = TextEditingController();
  final _udpFirstController = TextEditingController();
  final _udpSingleController = TextEditingController();
  final _udpMultipleController = TextEditingController();
  final _adaptiveStartController = TextEditingController();
  final _adaptiveEndController = TextEditingController();
  final _maxController = TextEditingController();
  final _maxSrcNodesController = TextEditingController();
  final _maxSrcStatesController = TextEditingController();
  final _maxSrcConnController = TextEditingController();
  final _maxSrcConnRateController = TextEditingController();
  final _maxSrcConnRatesController = TextEditingController();
  final _tagController = TextEditingController();
  final _taggedController = TextEditingController();

  // ── Organisation ─────────────────────────────────────────────────────────
  bool _enabled = true;
  List<String> _selectedCategories = [];

  // ── Interface ────────────────────────────────────────────────────────────
  String _selectedInterface = '';
  bool _interfaceNot = false;

  // ── Filter ───────────────────────────────────────────────────────────────
  bool _quick = true;
  String _selectedType = 'pass';
  String _selectedDirection = 'in';
  String _selectedIpProtocol = 'inet';
  String _selectedProtocol = 'any';
  String _selectedIcmpType = '';
  bool _invertSource = false;
  List<String> _sourceSelected = ['any'];
  String _sourcePortType = 'any';
  bool _invertDestination = false;
  List<String> _destinationSelected = ['any'];
  String _destinationPortType = 'any';
  bool _log = false;

  // ── Source Routing ───────────────────────────────────────────────────────
  String _selectedGateway = '';

  // ── Advanced — Organisation ──────────────────────────────────────────────
  bool _noSync = false;

  // ── Advanced — Filter ────────────────────────────────────────────────────
  bool _allowOpts = false;
  List<String> _tcpFlags1 = [];
  List<String> _tcpFlags2 = [];
  bool _tcpFlagsAny = false;
  String _selectedSchedule = '';
  String _selectedDivertTo = '';

  // ── Stateful Firewall ────────────────────────────────────────────────────
  String _selectedStateType = 'keep';
  String _selectedStatePolicy = '';
  bool _noPfsync = false;
  String _selectedOverload = '';

  // ── Traffic Shaping ──────────────────────────────────────────────────────
  String _selectedShaper1 = '';
  String _selectedShaper2 = '';

  // ── Advanced — Source Routing ────────────────────────────────────────────
  bool _disableReplyTo = false;
  String _selectedReplyTo = '';

  // ── Priority ─────────────────────────────────────────────────────────────
  String _selectedPrio = '';
  String _selectedSetPrio = '';
  String _selectedSetPrioLow = '';
  String _selectedTos = '';

  // ── UI state ─────────────────────────────────────────────────────────────
  bool _showAdvanced = false;

  // ──────────────────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _viewModel = FirewallRuleFormViewModel(
      apiService: context.read(),
      existingRule: widget.rule,
    );
    _viewModel.addListener(_onViewModelChanged);
    _viewModel.loadInterfaces();
    _viewModel.loadFormOptions();
    _viewModel.loadAliases();

    if (widget.isEditing) {
      _viewModel.loadFullRule();
    }
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    _descriptionController.dispose();
    _sourceController.dispose();
    _sourcePortController.dispose();
    _destinationController.dispose();
    _destinationPortController.dispose();
    _sequenceController.dispose();
    _statTimeoutController.dispose();
    _udpFirstController.dispose();
    _udpSingleController.dispose();
    _udpMultipleController.dispose();
    _adaptiveStartController.dispose();
    _adaptiveEndController.dispose();
    _maxController.dispose();
    _maxSrcNodesController.dispose();
    _maxSrcStatesController.dispose();
    _maxSrcConnController.dispose();
    _maxSrcConnRateController.dispose();
    _maxSrcConnRatesController.dispose();
    _tagController.dispose();
    _taggedController.dispose();
    super.dispose();
  }

  bool _ruleDataLoaded = false;

  void _onViewModelChanged() {
    if (!mounted) return;
    // Once the full rule has loaded, populate the form (once only).
    if (widget.isEditing && !_ruleDataLoaded && !_viewModel.loadingFullRule) {
      final full = _viewModel.fullRule;
      if (full != null) {
        _ruleDataLoaded = true;
        setState(() => _loadRuleData(full));
        return;
      }
    }
    setState(() {});
  }

  void _loadRuleData(FirewallRule rule) {
    _descriptionController.text = rule.description;

    // Source net — split comma-separated value into list of selected keys.
    _sourceSelected = _splitNetValue(rule.source);
    if (_sourceSelected.contains('single')) {
      _sourceController.text = rule.source
          .split(',')
          .where((v) => !_isFixedNetKey(v))
          .join(',');
    }

    // Source port
    if (rule.sourcePort.isEmpty || rule.sourcePort == 'any') {
      _sourcePortType = 'any';
    } else {
      _sourcePortType = 'single';
      _sourcePortController.text = rule.sourcePort;
    }

    // Destination net
    _destinationSelected = _splitNetValue(rule.destination);
    if (_destinationSelected.contains('single')) {
      _destinationController.text = rule.destination
          .split(',')
          .where((v) => !_isFixedNetKey(v))
          .join(',');
    }

    // Destination port
    if (rule.destinationPort.isEmpty || rule.destinationPort == 'any') {
      _destinationPortType = 'any';
    } else {
      _destinationPortType = 'single';
      _destinationPortController.text = rule.destinationPort;
    }
    _selectedCategories = List<String>.from(rule.categories);
    _sequenceController.text = rule.sequence > 0 ? rule.sequence.toString() : '';

    _selectedType = rule.type;
    _selectedInterface = rule.interfaceName;
    // Normalise to API-canonical casing: 'any' stays lowercase, everything else uppercase
    _selectedProtocol = rule.protocol.toLowerCase() == 'any'
        ? 'any'
        : rule.protocol.toUpperCase();
    _selectedIcmpType = rule.protocol.toLowerCase() == 'ipv6-icmp'
        ? rule.icmp6Type
        : rule.icmpType;
    _enabled = rule.isEnabled;
    _selectedDirection = rule.direction;
    _selectedIpProtocol = rule.ipProtocol;
    _quick = rule.quick == '1';
    _log = rule.log == '1';
    _selectedStateType = rule.stateType;
    _invertSource = rule.sourceNot == '1';
    _invertDestination = rule.destinationNot == '1';
    _interfaceNot = rule.interfaceNot == '1';
    _noSync = rule.noSync == '1';
    _allowOpts = rule.allowOpts == '1';
    _tcpFlags1 = List<String>.from(rule.tcpFlags1);
    _tcpFlags2 = List<String>.from(rule.tcpFlags2);
    _tcpFlagsAny = rule.tcpFlagsAny == '1';
    _selectedSchedule = rule.schedule;
    _selectedDivertTo = rule.divertTo;
    _selectedGateway = rule.gateway;
    _selectedReplyTo = rule.replyTo;
    _disableReplyTo = rule.disableReplyTo == '1';
    _selectedStatePolicy = rule.statePolicy;
    _noPfsync = rule.noPfsync == '1';
    _statTimeoutController.text = rule.statTimeout;
    _udpFirstController.text = rule.udpFirst;
    _udpSingleController.text = rule.udpSingle;
    _udpMultipleController.text = rule.udpMultiple;
    _adaptiveStartController.text = rule.adaptiveStart;
    _adaptiveEndController.text = rule.adaptiveEnd;
    _maxController.text = rule.max;
    _maxSrcNodesController.text = rule.maxSrcNodes;
    _maxSrcStatesController.text = rule.maxSrcStates;
    _maxSrcConnController.text = rule.maxSrcConn;
    _maxSrcConnRateController.text = rule.maxSrcConnRate;
    _maxSrcConnRatesController.text = rule.maxSrcConnRates;
    _selectedOverload = rule.overload;
    _selectedShaper1 = rule.shaper1;
    _selectedShaper2 = rule.shaper2;
    _selectedPrio = rule.prio;
    _selectedSetPrio = rule.setPrio;
    _selectedSetPrioLow = rule.setPrioLow;
    _selectedTos = rule.tos;
    _tagController.text = rule.tag;
    _taggedController.text = rule.tagged;
  }

  void _swapSourceDestination() {
    setState(() {
      final tempNet = _sourceController.text;
      _sourceController.text = _destinationController.text;
      _destinationController.text = tempNet;

      final tempPort = _sourcePortController.text;
      _sourcePortController.text = _destinationPortController.text;
      _destinationPortController.text = tempPort;

      final tempSelected = _sourceSelected;
      _sourceSelected = _destinationSelected;
      _destinationSelected = tempSelected;

      final tempPortType = _sourcePortType;
      _sourcePortType = _destinationPortType;
      _destinationPortType = tempPortType;

      final tempInvert = _invertSource;
      _invertSource = _invertDestination;
      _invertDestination = tempInvert;
    });
  }

  Future<void> _saveRule() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

    final request = FirewallRuleRequest(
      type: _selectedType,
      interfaceName: _selectedInterface,
      protocol: _selectedProtocol,
      icmpType: _selectedProtocol.toLowerCase() == 'icmp' ? _selectedIcmpType : '',
      icmp6Type: _selectedProtocol.toLowerCase() == 'ipv6-icmp' ? _selectedIcmpType : '',
      source: _encodeNetValue(_sourceSelected, _sourceController.text.trim()),
      destination: _encodeNetValue(_destinationSelected, _destinationController.text.trim()),
      destinationPort: _destinationPortType == 'any' ? '' : _destinationPortController.text.trim(),
      description: _descriptionController.text.trim(),
      enabled: _enabled ? '1' : '0',
      sourcePort: _sourcePortType == 'any' ? '' : _sourcePortController.text.trim(),
      direction: _selectedDirection,
      ipProtocol: _selectedIpProtocol,
      quick: _quick ? '1' : '0',
      log: _log ? '1' : '0',
      stateType: _selectedStateType,
      sourceNot: _invertSource ? '1' : '0',
      destinationNot: _invertDestination ? '1' : '0',
      interfaceNot: _interfaceNot ? '1' : '0',
      noSync: _noSync ? '1' : '0',
      sequence: _sequenceController.text.trim(),
      allowOpts: _allowOpts ? '1' : '0',
      tcpFlags1: _tcpFlags1,
      tcpFlags2: _tcpFlags2,
      tcpFlagsAny: _tcpFlagsAny ? '1' : '0',
      schedule: _selectedSchedule,
      divertTo: _selectedDivertTo,
      gateway: _selectedGateway,
      replyTo: _selectedReplyTo,
      disableReplyTo: _disableReplyTo ? '1' : '0',
      statePolicy: _selectedStatePolicy,
      noPfsync: _noPfsync ? '1' : '0',
      statTimeout: _statTimeoutController.text.trim(),
      udpFirst: _udpFirstController.text.trim(),
      udpSingle: _udpSingleController.text.trim(),
      udpMultiple: _udpMultipleController.text.trim(),
      adaptiveStart: _adaptiveStartController.text.trim(),
      adaptiveEnd: _adaptiveEndController.text.trim(),
      max: _maxController.text.trim(),
      maxSrcNodes: _maxSrcNodesController.text.trim(),
      maxSrcStates: _maxSrcStatesController.text.trim(),
      maxSrcConn: _maxSrcConnController.text.trim(),
      maxSrcConnRate: _maxSrcConnRateController.text.trim(),
      maxSrcConnRates: _maxSrcConnRatesController.text.trim(),
      overload: _selectedOverload,
      shaper1: _selectedShaper1,
      shaper2: _selectedShaper2,
      prio: _selectedPrio,
      setPrio: _selectedSetPrio,
      setPrioLow: _selectedSetPrioLow,
      tos: _selectedTos,
      tag: _tagController.text.trim(),
      tagged: _taggedController.text.trim(),
      categories: _selectedCategories,
    );

    final success = await _viewModel.saveRule(request);

    if (mounted) {
      if (success) {
        SnackBarHelper.showInfo(context, widget.isEditing ? l10n.ruleUpdated : l10n.ruleCreated);
        Navigator.of(context).pop();
      } else {
        SnackBarHelper.showInfo(context, _viewModel.errorMessage ?? l10n.errorSavingRule(''));
      }
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Helpers
  // ──────────────────────────────────────────────────────────────────────────

  bool get _isLoading => _viewModel.isLoading;
  bool get _supportsPorts {
    final p = _selectedProtocol.toLowerCase();
    return p == 'tcp' || p == 'udp' || p == 'tcp/udp';
  }

  bool get _showIcmpType =>
      _selectedProtocol.toLowerCase() == 'icmp' ||
      _selectedProtocol.toLowerCase() == 'ipv6-icmp';

  /// True if [v] is a known fixed option (not a raw IP/CIDR).
  bool _isFixedNetKey(String v) {
    if (v.isEmpty || v == 'any' || v == '(self)') return true;
    final ifaces = _viewModel.availableInterfaces;
    if (ifaces.containsKey(v)) return true;
    for (final k in ifaces.keys) {
      if (v == '${k}ip') return true;
    }
    if (_viewModel.aliases.containsKey(v)) return true;
    return false;
  }

  /// Splits a comma-separated API value into a list of selected option keys.
  /// Any part that is not a fixed key is lumped under 'single'.
  List<String> _splitNetValue(String raw) {
    if (raw.isEmpty || raw == 'any') return ['any'];
    final parts = raw.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty);
    final result = <String>[];
    for (final p in parts) {
      if (_isFixedNetKey(p)) {
        result.add(p);
      } else {
        if (!result.contains('single')) result.add('single');
      }
    }
    return result.isEmpty ? ['any'] : result;
  }

  /// Joins the selected list back to a comma-separated API value.
  /// 'single' entries are replaced by the free-text controller value.
  String _encodeNetValue(List<String> selected, String freeText) {
    final parts = <String>[];
    for (final s in selected) {
      if (s == 'single') {
        final t = freeText.trim();
        if (t.isNotEmpty) parts.add(t);
      } else {
        parts.add(s);
      }
    }
    return parts.isEmpty ? 'any' : parts.join(',');
  }

  /// Builds the full Source/Destination option map.
  /// Groups: Fixed (any/self), Interface nets, Interface addresses, Aliases, Custom
  Map<String, String> _buildNetOptions() {
    final l10n = AppLocalizations.of(context)!;
    final opts = <String, String>{'any': l10n.any};
    final ifaces = _viewModel.availableInterfaces;
    for (final e in ifaces.entries) {
      final key = e.key.toString();
      final label = e.value.toString();
      opts[key] = l10n.interfaceNet(label);
    }
    for (final e in ifaces.entries) {
      final key = e.key.toString();
      final label = e.value.toString();
      opts['${key}ip'] = l10n.interfaceAddress(label);
    }
    opts['(self)'] = l10n.thisFirwall;
    for (final a in _viewModel.aliases.keys) {
      opts[a] = a;
    }
    opts['single'] = l10n.singleHostOrNetwork;
    return opts;
  }

  /// Opens a searchable multi-select bottom sheet for source/destination.
  Future<void> _openNetPicker({
    required String label,
    required List<String> selected,
    required ValueChanged<List<String>> onChanged,
  }) async {
    final opts = _buildNetOptions();
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _PickerSheet(
        title: label,
        options: opts,
        initialSelected: selected,
        isLoading: false,
        searchHint: AppLocalizations.of(context)!.searchAliases,
        doneLabel: AppLocalizations.of(context)!.done,
        emptyLabel: AppLocalizations.of(context)!.noItemsConfigured,
        showSubtitle: true,
        onDone: onChanged,
      ),
    );
  }

  /// Builds the tappable chip row + optional free-text field for a net picker.
  Widget _buildNetPickerField({
    required String label,
    required IconData icon,
    required List<String> selected,
    required ValueChanged<List<String>> onChanged,
    required TextEditingController freeTextCtrl,
    required String? Function(String?) freeTextValidator,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final opts = _buildNetOptions();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: _isLoading
              ? null
              : () => _openNetPicker(
                    label: label,
                    selected: selected,
                    onChanged: (v) => setState(() => onChanged(v)),
                  ),
          borderRadius: BorderRadius.circular(8),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: label,
              prefixIcon: Icon(icon),
              suffixIcon: const Icon(Icons.arrow_drop_down),
            ),
            child: Wrap(
              spacing: 6,
              runSpacing: 4,
              children: selected.map((k) {
                final display = k == 'single'
                    ? l10n.singleHostOrNetwork
                    : (opts[k] ?? k);
                return Chip(
                  label: Text(display,
                      style: const TextStyle(fontSize: 12)),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                );
              }).toList(),
            ),
          ),
        ),
        if (selected.contains('single')) ...[
          const SizedBox(height: 8),
          TextFormField(
            controller: freeTextCtrl,
            decoration: InputDecoration(
              labelText: l10n.singleHostOrNetwork,
              hintText: l10n.anyIpAddressCidrOrAlias,
              prefixIcon: const Icon(Icons.edit_outlined),
              helperText: l10n.examplesAnyIpCidr,
            ),
            validator: freeTextValidator,
            enabled: !_isLoading,
          ),
        ],
      ],
    );
  }

  /// Tappable chip row for category multi-select, backed by opts.categories.
  Widget _buildCategoryPickerField(FirewallFormOptions opts) {
    final l10n = AppLocalizations.of(context)!;
    final categoryOpts = opts.categories;

    Future<void> openPicker() async {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (_) => _PickerSheet(
          title: l10n.categoriesLabel,
          options: categoryOpts,
          initialSelected: _selectedCategories,
          isLoading: _viewModel.loadingOptions,
          searchHint: l10n.searchAliases,
          doneLabel: l10n.done,
          emptyLabel: l10n.noItemsConfigured,
          showSubtitle: false,
          onDone: (result) => setState(() => _selectedCategories = result),
        ),
      );
    }

    return InkWell(
      onTap: _isLoading ? null : openPicker,
      borderRadius: BorderRadius.circular(8),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: l10n.categoriesLabel,
          prefixIcon: const Icon(Icons.label_outline),
          suffixIcon: const Icon(Icons.arrow_drop_down),
          helperText: l10n.categoriesHint,
          helperMaxLines: 2,
        ),
        child: _selectedCategories.isEmpty
            ? Text(l10n.categoriesHint,
                style: TextStyle(color: Theme.of(context).hintColor))
            : Wrap(
                spacing: 6,
                runSpacing: 4,
                children: _selectedCategories.map((k) {
                  final label = categoryOpts[k] ?? k;
                  return Chip(
                    label: Text(label, style: const TextStyle(fontSize: 12)),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    onDeleted: _isLoading
                        ? null
                        : () => setState(() => _selectedCategories.remove(k)),
                  );
                }).toList(),
              ),
      ),
    );
  }

  /// Tappable chip field for single-select protocol picker.
  Widget _buildProtocolPickerField() {
    final l10n = AppLocalizations.of(context)!;
    final displayLabel = _kProtocols[_selectedProtocol] ?? _selectedProtocol;

    return InkWell(
      onTap: _isLoading
          ? null
          : () async {
              await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (_) => _PickerSheet(
                  title: l10n.protocol,
                  options: _kProtocols,
                  initialSelected: [_selectedProtocol],
                  isLoading: false,
                  searchHint: l10n.protocol,
                  doneLabel: l10n.done,
                  emptyLabel: l10n.noItemsConfigured,
                  showSubtitle: false,
                  singleSelect: true,
                  onDone: (result) => setState(() {
                    _selectedProtocol = result.isNotEmpty ? result.first : 'any';
                    // Reset ICMP sub-type when protocol changes
                    _selectedIcmpType = '';
                  }),
                ),
              );
            },
      borderRadius: BorderRadius.circular(8),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: l10n.protocol,
          prefixIcon: const Icon(Icons.settings_ethernet),
          suffixIcon: const Icon(Icons.arrow_drop_down),
        ),
        child: Text(displayLabel),
      ),
    );
  }

  /// Build a dropdown from a String→String map (API-sourced options).
  Widget _buildApiDropdown({
    required String label,
    required String value,
    required Map<String, String> options,
    required ValueChanged<String?> onChanged,
    String? helperText,
    bool isLoading = false,
  }) {
    // Ensure the current value is in options; fallback to first key
    final effectiveValue =
        options.containsKey(value) ? value : options.keys.first;

    return DropdownButtonFormField<String>(
      initialValue: effectiveValue,
      decoration: InputDecoration(
        labelText: label,
        helperText: helperText,
        helperMaxLines: 3,
      ),
      items: isLoading
          ? [DropdownMenuItem(value: effectiveValue, child: Text(_viewModel.loadingOptions ? '...' : label))]
          : options.entries
              .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
              .toList(),
      onChanged: _isLoading || isLoading ? null : onChanged,
    );
  }

  /// Section card wrapping an ExpansionTile.
  Widget _section({
    required String title,
    required IconData icon,
    required List<Widget> children,
    bool initiallyExpanded = true,
  }) {
    return Card(
      margin: EdgeInsets.zero,
      child: ExpansionTile(
        leading: Icon(icon),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        initiallyExpanded: initiallyExpanded,
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [const SizedBox(height: 8), ...children],
      ),
    );
  }

  Widget _gap([double h = 16]) => SizedBox(height: h);

  // ──────────────────────────────────────────────────────────────────────────
  // Build
  // ──────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final opts = _viewModel.formOptions;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? l10n.editRule : l10n.newRule),
      ),
      body: LoadingOverlay(
        isLoading: _viewModel.isLoading,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppConstants.standardPadding * 2),
            children: [
              // ── Advanced toggle ───────────────────────────────────────────
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton.icon(
                  onPressed: () => setState(() => _showAdvanced = !_showAdvanced),
                  icon: Icon(_showAdvanced ? Icons.visibility_off : Icons.tune),
                  label: Text(_showAdvanced ? l10n.hideAdvanced : l10n.showAdvanced),
                ),
              ),
              _gap(),

              // ── ORGANISATION ──────────────────────────────────────────────
              _section(
                title: l10n.organisationSection,
                icon: Icons.folder_outlined,
                children: [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.enabled),
                    subtitle: Text(l10n.enableThisRule),
                    value: _enabled,
                    onChanged: _isLoading ? null : (v) => setState(() => _enabled = v),
                  ),
                  _gap(),
                  _buildCategoryPickerField(opts),
                  _gap(),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: l10n.description,
                      hintText: l10n.enterRuleDescription,
                      prefixIcon: const Icon(Icons.description),
                      helperText: l10n.descriptionHelperTextOverride,
                      helperMaxLines: 3,
                    ),
                    enabled: !_isLoading,
                  ),
                ],
              ),
              _gap(),

              // ── INTERFACE ─────────────────────────────────────────────────
              _section(
                title: l10n.interfaceSection,
                icon: Icons.network_check,
                children: [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.invertInterface),
                    subtitle: Text(l10n.invertInterfaceSubtitle),
                    value: _interfaceNot,
                    onChanged: _isLoading ? null : (v) => setState(() => _interfaceNot = v),
                  ),
                  _gap(),
                  DropdownButtonFormField<String>(
                    initialValue: () {
                      if (_viewModel.loadingInterfaces) return null;
                      final ifaces = _viewModel.availableInterfaces;
                      // '' is always valid (Any), named keys only valid if loaded
                      if (_selectedInterface == '' ||
                          ifaces.containsKey(_selectedInterface)) {
                        return _selectedInterface;
                      }
                      return '';
                    }(),
                    decoration: InputDecoration(
                      labelText: l10n.interface,
                      prefixIcon: const Icon(Icons.network_check),
                    ),
                    items: _viewModel.loadingInterfaces
                        ? [DropdownMenuItem(value: '', child: Text(l10n.loading))]
                        : [
                            DropdownMenuItem(value: '', child: Text(l10n.any)),
                            ..._viewModel.availableInterfaces.entries
                                .map((e) => DropdownMenuItem(
                                      value: e.key,
                                      child: Text(e.value),
                                    )),
                          ],
                    onChanged: _isLoading || _viewModel.loadingInterfaces
                        ? null
                        : (v) {
                            if (v != null) {
                              setState(() => _selectedInterface = v);
                            }
                          },
                  ),
                ],
              ),
              _gap(),

              // ── FILTER ────────────────────────────────────────────────────
              _section(
                title: l10n.filterSection,
                icon: Icons.filter_alt_outlined,
                children: [
                  // Quick
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.quickRule),
                    subtitle: Text(l10n.quickRuleHelp),
                    value: _quick,
                    onChanged: _isLoading ? null : (v) => setState(() => _quick = v),
                  ),
                  _gap(),

                  // Action
                  DropdownButtonFormField<String>(
                    initialValue: _selectedType,
                    decoration: InputDecoration(
                      labelText: l10n.action,
                      prefixIcon: const Icon(Icons.rule),
                      helperText: l10n.actionHelp,
                      helperMaxLines: 4,
                    ),
                    items: [
                      DropdownMenuItem(value: 'pass', child: Text(l10n.pass)),
                      DropdownMenuItem(value: 'block', child: Text(l10n.block)),
                      DropdownMenuItem(value: 'reject', child: Text(l10n.reject)),
                    ],
                    onChanged: _isLoading
                        ? null
                        : (v) { if (v != null) setState(() => _selectedType = v); },
                  ),
                  _gap(),

                  // Direction
                  DropdownButtonFormField<String>(
                    initialValue: _selectedDirection,
                    decoration: InputDecoration(
                      labelText: l10n.direction,
                      prefixIcon: const Icon(Icons.compare_arrows),
                      helperText: l10n.directionHelp,
                      helperMaxLines: 3,
                    ),
                    items: [
                      DropdownMenuItem(value: 'in', child: Text(l10n.directionIn)),
                      DropdownMenuItem(value: 'out', child: Text(l10n.directionOut)),
                      DropdownMenuItem(value: 'any', child: Text(l10n.directionBoth)),
                    ],
                    onChanged: _isLoading
                        ? null
                        : (v) { if (v != null) setState(() => _selectedDirection = v); },
                  ),
                  _gap(),

                  // IP Version
                  DropdownButtonFormField<String>(
                    initialValue: _selectedIpProtocol,
                    decoration: InputDecoration(
                      labelText: l10n.fwVersionLabel,
                      prefixIcon: const Icon(Icons.lan),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'inet', child: Text('IPv4')),
                      DropdownMenuItem(value: 'inet6', child: Text('IPv6')),
                      DropdownMenuItem(value: 'inet46', child: Text('any')),
                    ],
                    onChanged: _isLoading
                        ? null
                        : (v) { if (v != null) setState(() => _selectedIpProtocol = v); },
                  ),
                  _gap(),

                  // Protocol
                  _buildProtocolPickerField(),

                  // ICMP Type — only shown for ICMP / IPV6-ICMP
                  if (_showIcmpType) ...[
                    _gap(),
                    DropdownButtonFormField<String>(
                      key: ValueKey(_selectedIcmpType),
                      initialValue: _kIcmp6Types.containsKey(_selectedIcmpType) || _kIcmpTypes.containsKey(_selectedIcmpType)
                          ? _selectedIcmpType
                          : '',
                      decoration: InputDecoration(
                        labelText: _selectedProtocol.toLowerCase() == 'ipv6-icmp'
                            ? l10n.icmp6TypeLabel
                            : l10n.icmpTypeLabel,
                        prefixIcon: const Icon(Icons.error_outline),
                      ),
                      items: (_selectedProtocol.toLowerCase() == 'ipv6-icmp' ? _kIcmp6Types : _kIcmpTypes)
                          .entries
                          .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
                          .toList(),
                      onChanged: _isLoading
                          ? null
                          : (v) { if (v != null) setState(() => _selectedIcmpType = v); },
                    ),
                  ],
                  _gap(),

                  // ── Source block ─────────────────────────────────────────
                  // Invert Source
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.invertSource),
                    value: _invertSource,
                    onChanged: _isLoading ? null : (v) => setState(() => _invertSource = v),
                  ),
                  _gap(8),
                  _buildNetPickerField(
                    label: l10n.source,
                    icon: Icons.arrow_forward,
                    selected: _sourceSelected,
                    onChanged: (v) => _sourceSelected = v,
                    freeTextCtrl: _sourceController,
                    freeTextValidator: (v) {
                      if (!_sourceSelected.contains('single')) return null;
                      if (v == null || v.isEmpty) return l10n.sourceIsRequired;
                      if (!Validators.isValidSourceDestination(v)) return l10n.invalidSourceFormat;
                      return null;
                    },
                  ),

                  // Source Port (TCP/UDP only)
                  if (_supportsPorts) ...[
                    _gap(8),
                    DropdownButtonFormField<String>(
                      initialValue: _sourcePortType,
                      decoration: InputDecoration(
                        labelText: l10n.sourcePortOptional,
                        prefixIcon: const Icon(Icons.input),
                        helperText: l10n.sourcePortHelp,
                        helperMaxLines: 3,
                      ),
                      items: [
                        DropdownMenuItem(value: 'any', child: Text(l10n.any)),
                        DropdownMenuItem(value: 'single', child: Text(l10n.singlePortOrRange)),
                      ],
                      onChanged: _isLoading
                          ? null
                          : (v) {
                              if (v != null) setState(() => _sourcePortType = v);
                            },
                    ),
                    if (_sourcePortType == 'single') ...[
                      _gap(8),
                      TextFormField(
                        controller: _sourcePortController,
                        decoration: InputDecoration(
                          labelText: l10n.singlePortOrRange,
                          hintText: l10n.anyPortNumberRangeOrAlias,
                          prefixIcon: const Icon(Icons.input),
                        ),
                        validator: (v) {
                          if (_sourcePortType != 'single') return null;
                          if (v == null || v.isEmpty) return null;
                          if (!Validators.isValidDestinationPort(v)) return l10n.invalidPortFormat;
                          return null;
                        },
                        enabled: !_isLoading,
                      ),
                    ],
                  ],
                  _gap(8),

                  // Swap button
                  Center(
                    child: TextButton.icon(
                      onPressed: _isLoading ? null : _swapSourceDestination,
                      icon: const Icon(Icons.swap_vert),
                      label: Text(l10n.swapSourceDestination),
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  _gap(8),

                  // ── Destination block ────────────────────────────────────
                  // Invert Destination
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.invertDestination),
                    value: _invertDestination,
                    onChanged: _isLoading ? null : (v) => setState(() => _invertDestination = v),
                  ),
                  _gap(8),
                  _buildNetPickerField(
                    label: l10n.destination,
                    icon: Icons.location_on,
                    selected: _destinationSelected,
                    onChanged: (v) => _destinationSelected = v,
                    freeTextCtrl: _destinationController,
                    freeTextValidator: (v) {
                      if (!_destinationSelected.contains('single')) return null;
                      if (v == null || v.isEmpty) return l10n.destinationIsRequired;
                      if (!Validators.isValidSourceDestination(v)) return l10n.invalidDestinationFormat;
                      return null;
                    },
                  ),

                  // Destination Port (TCP/UDP only)
                  if (_supportsPorts) ...[
                    _gap(8),
                    DropdownButtonFormField<String>(
                      initialValue: _destinationPortType,
                      decoration: InputDecoration(
                        labelText: l10n.destinationPortOptional,
                        prefixIcon: const Icon(Icons.settings_input_component),
                        helperText: l10n.destinationPortHelp,
                        helperMaxLines: 3,
                      ),
                      items: [
                        DropdownMenuItem(value: 'any', child: Text(l10n.any)),
                        DropdownMenuItem(value: 'single', child: Text(l10n.singlePortOrRange)),
                      ],
                      onChanged: _isLoading
                          ? null
                          : (v) {
                              if (v != null) setState(() => _destinationPortType = v);
                            },
                    ),
                    if (_destinationPortType == 'single') ...[
                      _gap(8),
                      TextFormField(
                        controller: _destinationPortController,
                        decoration: InputDecoration(
                          labelText: l10n.singlePortOrRange,
                          hintText: l10n.anyPortNumberRangeOrAlias,
                          prefixIcon: const Icon(Icons.settings_input_component),
                        ),
                        validator: (v) {
                          if (_destinationPortType != 'single') return null;
                          if (v == null || v.isEmpty) return null;
                          if (!Validators.isValidDestinationPort(v)) return l10n.invalidPortFormat;
                          return null;
                        },
                        enabled: !_isLoading,
                      ),
                    ],
                  ],
                  _gap(),

                  // Log
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.logTraffic),
                    subtitle: Text(l10n.logHelp),
                    value: _log,
                    onChanged: _isLoading ? null : (v) => setState(() => _log = v),
                  ),
                ],
              ),
              _gap(),

              // ── SOURCE ROUTING ────────────────────────────────────────────
              _section(
                title: l10n.sourceRoutingSection,
                icon: Icons.route_outlined,
                children: [
                  _buildApiDropdown(
                    label: l10n.fwGatewayLabel,
                    value: _selectedGateway,
                    options: opts.gateways,
                    helperText: l10n.gatewayHelp,
                    isLoading: _viewModel.loadingOptions,
                    onChanged: (v) { if (v != null) setState(() => _selectedGateway = v); },
                  ),
                ],
              ),
              _gap(),

              // ── ADVANCED SECTIONS (conditionally shown) ───────────────────
              if (_showAdvanced) ...[

                // ── ADVANCED ORGANISATION ─────────────────────────────────
                _section(
                  title: l10n.organisationSection,
                  icon: Icons.manage_search,
                  initiallyExpanded: false,
                  children: [
                    // Sort Order — read-only display (value from existing rule only)
                    if (widget.isEditing && widget.rule!.sortOrder.isNotEmpty) ...[
                      TextFormField(
                        initialValue: widget.rule!.sortOrder,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: l10n.sortOrderLabel,
                          prefixIcon: const Icon(Icons.format_list_numbered_outlined),
                          helperText: l10n.sortOrderHelp,
                          helperMaxLines: 3,
                          filled: true,
                        ),
                      ),
                      _gap(),
                    ],
                    TextFormField(
                      controller: _sequenceController,
                      decoration: InputDecoration(
                        labelText: l10n.sequenceLabel,
                        prefixIcon: const Icon(Icons.format_list_numbered),
                        helperText: l10n.sequenceHelp,
                        helperMaxLines: 3,
                      ),
                      keyboardType: TextInputType.number,
                      enabled: !_isLoading,
                    ),
                    _gap(),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.noXmlrpcSync),
                      subtitle: Text(l10n.noXmlrpcSyncHelp),
                      value: _noSync,
                      onChanged: _isLoading ? null : (v) => setState(() => _noSync = v),
                    ),
                  ],
                ),
                _gap(),

                // ── ADVANCED FILTER ───────────────────────────────────────
                _section(
                  title: l10n.filterSection,
                  icon: Icons.filter_list,
                  initiallyExpanded: false,
                  children: [
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.allowOptionsLabel),
                      subtitle: Text(l10n.allowOptionsHelp),
                      value: _allowOpts,
                      onChanged: _isLoading ? null : (v) => setState(() => _allowOpts = v),
                    ),
                    _gap(),

                    // TCP Flags (must be set)
                    Text(l10n.tcpFlagsLabel,
                        style: Theme.of(context).textTheme.bodySmall),
                    _gap(4),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: _kTcpFlagNames.map((flag) => FilterChip(
                        label: Text(flag),
                        selected: _tcpFlags1.contains(flag),
                        onSelected: _isLoading
                            ? null
                            : (sel) => setState(() {
                                  if (sel) {
                                    _tcpFlags1 = [..._tcpFlags1, flag];
                                  } else {
                                    _tcpFlags1 = _tcpFlags1.where((f) => f != flag).toList();
                                  }
                                }),
                      )).toList(),
                    ),
                    _gap(),

                    // TCP Flags [out of]
                    Text(l10n.tcpFlagsOutLabel,
                        style: Theme.of(context).textTheme.bodySmall),
                    _gap(4),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: _kTcpFlagNames.map((flag) => FilterChip(
                        label: Text(flag),
                        selected: _tcpFlags2.contains(flag),
                        onSelected: _isLoading
                            ? null
                            : (sel) => setState(() {
                                  if (sel) {
                                    _tcpFlags2 = [..._tcpFlags2, flag];
                                  } else {
                                    _tcpFlags2 = _tcpFlags2.where((f) => f != flag).toList();
                                  }
                                }),
                      )).toList(),
                    ),
                    _gap(),

                    // TCP Flags Any
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.tcpFlagsAnyLabel),
                      value: _tcpFlagsAny,
                      onChanged: _isLoading ? null : (v) => setState(() => _tcpFlagsAny = v),
                    ),
                    _gap(),

                    // Schedule
                    _buildApiDropdown(
                      label: l10n.scheduleLabel,
                      value: _selectedSchedule,
                      options: opts.schedules,
                      isLoading: _viewModel.loadingOptions,
                      onChanged: (v) { if (v != null) setState(() => _selectedSchedule = v); },
                    ),
                    _gap(),

                    // Divert-to
                    _buildApiDropdown(
                      label: l10n.divertToLabel,
                      value: _selectedDivertTo,
                      options: opts.divertTo,
                      helperText: l10n.divertToHelp,
                      isLoading: _viewModel.loadingOptions,
                      onChanged: (v) { if (v != null) setState(() => _selectedDivertTo = v); },
                    ),
                  ],
                ),
                _gap(),

                // ── STATEFUL FIREWALL ─────────────────────────────────────
                _section(
                  title: l10n.statefulFirewallSection,
                  icon: Icons.account_tree_outlined,
                  initiallyExpanded: false,
                  children: [
                    // State Type
                    DropdownButtonFormField<String>(
                      initialValue: _selectedStateType,
                      decoration: InputDecoration(
                        labelText: l10n.stateType,
                        prefixIcon: const Icon(Icons.account_tree_outlined),
                      ),
                      items: [
                        DropdownMenuItem(value: 'keep', child: Text(l10n.keepState)),
                        DropdownMenuItem(value: 'sloppy', child: Text(l10n.sloppyState)),
                        DropdownMenuItem(value: 'modulate', child: Text(l10n.modulateState)),
                        DropdownMenuItem(value: 'synproxy', child: Text(l10n.synproxyState)),
                        DropdownMenuItem(value: 'none', child: Text(l10n.noState)),
                      ],
                      onChanged: _isLoading
                          ? null
                          : (v) { if (v != null) setState(() => _selectedStateType = v); },
                    ),
                    _gap(),

                    // State Policy
                    DropdownButtonFormField<String>(
                      initialValue: _selectedStatePolicy,
                      decoration: InputDecoration(
                        labelText: l10n.statePolicyLabel,
                        prefixIcon: const Icon(Icons.policy_outlined),
                      ),
                      items: const [
                        DropdownMenuItem(value: '', child: Text('default')),
                        DropdownMenuItem(value: 'if-bound', child: Text('Bind states to interface')),
                        DropdownMenuItem(value: 'floating', child: Text('Floating states')),
                      ],
                      onChanged: _isLoading
                          ? null
                          : (v) { if (v != null) setState(() => _selectedStatePolicy = v); },
                    ),
                    _gap(),

                    // No pfsync
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.noPfsyncLabel),
                      subtitle: Text(l10n.noPfsyncHelp),
                      value: _noPfsync,
                      onChanged: _isLoading ? null : (v) => setState(() => _noPfsync = v),
                    ),
                    _gap(),

                    // Timeout fields
                    TextFormField(
                      controller: _statTimeoutController,
                      decoration: InputDecoration(
                        labelText: l10n.tcpEstablishedLabel,
                        prefixIcon: const Icon(Icons.timer_outlined),
                      ),
                      keyboardType: TextInputType.number,
                      enabled: !_isLoading,
                    ),
                    _gap(),
                    TextFormField(
                      controller: _udpFirstController,
                      decoration: InputDecoration(
                        labelText: l10n.udpFirstLabel,
                        prefixIcon: const Icon(Icons.timer_outlined),
                      ),
                      keyboardType: TextInputType.number,
                      enabled: !_isLoading,
                    ),
                    _gap(),
                    TextFormField(
                      controller: _udpSingleController,
                      decoration: InputDecoration(
                        labelText: l10n.udpSingleLabel,
                        prefixIcon: const Icon(Icons.timer_outlined),
                      ),
                      keyboardType: TextInputType.number,
                      enabled: !_isLoading,
                    ),
                    _gap(),
                    TextFormField(
                      controller: _udpMultipleController,
                      decoration: InputDecoration(
                        labelText: l10n.udpMultipleLabel,
                        prefixIcon: const Icon(Icons.timer_outlined),
                      ),
                      keyboardType: TextInputType.number,
                      enabled: !_isLoading,
                    ),
                    _gap(),
                    TextFormField(
                      controller: _adaptiveStartController,
                      decoration: InputDecoration(
                        labelText: l10n.adaptiveStartLabel,
                        prefixIcon: const Icon(Icons.start),
                      ),
                      keyboardType: TextInputType.number,
                      enabled: !_isLoading,
                    ),
                    _gap(),
                    TextFormField(
                      controller: _adaptiveEndController,
                      decoration: InputDecoration(
                        labelText: l10n.adaptiveEndLabel,
                        prefixIcon: const Icon(Icons.stop),
                      ),
                      keyboardType: TextInputType.number,
                      enabled: !_isLoading,
                    ),
                    _gap(),
                    TextFormField(
                      controller: _maxController,
                      decoration: InputDecoration(
                        labelText: l10n.maxStatesLabel,
                        prefixIcon: const Icon(Icons.numbers),
                      ),
                      keyboardType: TextInputType.number,
                      enabled: !_isLoading,
                    ),
                    _gap(),
                    TextFormField(
                      controller: _maxSrcNodesController,
                      decoration: InputDecoration(
                        labelText: l10n.maxSrcNodesLabel,
                        prefixIcon: const Icon(Icons.numbers),
                      ),
                      keyboardType: TextInputType.number,
                      enabled: !_isLoading,
                    ),
                    _gap(),
                    TextFormField(
                      controller: _maxSrcStatesController,
                      decoration: InputDecoration(
                        labelText: l10n.maxSrcStatesLabel,
                        prefixIcon: const Icon(Icons.numbers),
                      ),
                      keyboardType: TextInputType.number,
                      enabled: !_isLoading,
                    ),
                    _gap(),
                    TextFormField(
                      controller: _maxSrcConnController,
                      decoration: InputDecoration(
                        labelText: l10n.maxSrcConnLabel,
                        prefixIcon: const Icon(Icons.numbers),
                      ),
                      keyboardType: TextInputType.number,
                      enabled: !_isLoading,
                    ),
                    _gap(),
                    TextFormField(
                      controller: _maxSrcConnRateController,
                      decoration: InputDecoration(
                        labelText: l10n.maxNewConnCLabel,
                        prefixIcon: const Icon(Icons.numbers),
                      ),
                      keyboardType: TextInputType.number,
                      enabled: !_isLoading,
                    ),
                    _gap(),
                    TextFormField(
                      controller: _maxSrcConnRatesController,
                      decoration: InputDecoration(
                        labelText: l10n.maxNewConnSLabel,
                        prefixIcon: const Icon(Icons.numbers),
                      ),
                      keyboardType: TextInputType.number,
                      enabled: !_isLoading,
                    ),
                    _gap(),
                    _buildApiDropdown(
                      label: l10n.overloadTableLabel,
                      value: _selectedOverload,
                      options: opts.overload,
                      helperText: l10n.overloadTableHelp,
                      isLoading: _viewModel.loadingOptions,
                      onChanged: (v) { if (v != null) setState(() => _selectedOverload = v); },
                    ),
                  ],
                ),
                _gap(),

                // ── TRAFFIC SHAPING ───────────────────────────────────────
                _section(
                  title: l10n.trafficShapingSection,
                  icon: Icons.speed_outlined,
                  initiallyExpanded: false,
                  children: [
                    _buildApiDropdown(
                      label: l10n.shaperLabel,
                      value: _selectedShaper1,
                      options: opts.shapers,
                      isLoading: _viewModel.loadingOptions,
                      onChanged: (v) { if (v != null) setState(() => _selectedShaper1 = v); },
                    ),
                    _gap(),
                    _buildApiDropdown(
                      label: l10n.shaperReverseLabel,
                      value: _selectedShaper2,
                      options: opts.shapers,
                      isLoading: _viewModel.loadingOptions,
                      onChanged: (v) { if (v != null) setState(() => _selectedShaper2 = v); },
                    ),
                  ],
                ),
                _gap(),

                // ── ADVANCED SOURCE ROUTING ───────────────────────────────
                _section(
                  title: l10n.sourceRoutingSection,
                  icon: Icons.reply_outlined,
                  initiallyExpanded: false,
                  children: [
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.disableReplyToLabel),
                      subtitle: Text(l10n.disableReplyToHelp),
                      value: _disableReplyTo,
                      onChanged: _isLoading ? null : (v) => setState(() => _disableReplyTo = v),
                    ),
                    _gap(),
                    _buildApiDropdown(
                      label: l10n.replyToLabel,
                      value: _selectedReplyTo,
                      options: opts.replyTo,
                      helperText: l10n.replyToHelp,
                      isLoading: _viewModel.loadingOptions,
                      onChanged: (v) { if (v != null) setState(() => _selectedReplyTo = v); },
                    ),
                  ],
                ),
                _gap(),

                // ── PRIORITY ──────────────────────────────────────────────
                _section(
                  title: l10n.prioritySection,
                  icon: Icons.low_priority_outlined,
                  initiallyExpanded: false,
                  children: [
                    _buildApiDropdown(
                      label: l10n.matchPriorityLabel,
                      value: _selectedPrio,
                      options: opts.prio,
                      isLoading: _viewModel.loadingOptions,
                      onChanged: (v) { if (v != null) setState(() => _selectedPrio = v); },
                    ),
                    _gap(),
                    _buildApiDropdown(
                      label: l10n.setPriorityLabel,
                      value: _selectedSetPrio,
                      options: opts.setPrio,
                      isLoading: _viewModel.loadingOptions,
                      onChanged: (v) { if (v != null) setState(() => _selectedSetPrio = v); },
                    ),
                    _gap(),
                    _buildApiDropdown(
                      label: l10n.setPriorityLowLabel,
                      value: _selectedSetPrioLow,
                      options: opts.setPrio,
                      isLoading: _viewModel.loadingOptions,
                      onChanged: (v) { if (v != null) setState(() => _selectedSetPrioLow = v); },
                    ),
                    _gap(),
                    _buildApiDropdown(
                      label: l10n.matchTosLabel,
                      value: _selectedTos,
                      options: opts.tos,
                      isLoading: _viewModel.loadingOptions,
                      onChanged: (v) { if (v != null) setState(() => _selectedTos = v); },
                    ),
                  ],
                ),
                _gap(),

                // ── INTERNAL TAGGING ──────────────────────────────────────
                _section(
                  title: l10n.internalTaggingSection,
                  icon: Icons.local_offer_outlined,
                  initiallyExpanded: false,
                  children: [
                    TextFormField(
                      controller: _tagController,
                      decoration: InputDecoration(
                        labelText: l10n.setLocalTagLabel,
                        prefixIcon: const Icon(Icons.sell_outlined),
                        helperText: l10n.setLocalTagHelp,
                        helperMaxLines: 4,
                      ),
                      enabled: !_isLoading,
                    ),
                    _gap(),
                    TextFormField(
                      controller: _taggedController,
                      decoration: InputDecoration(
                        labelText: l10n.matchLocalTagLabel,
                        prefixIcon: const Icon(Icons.label_important_outline),
                        helperText: l10n.matchLocalTagHelp,
                        helperMaxLines: 3,
                      ),
                      enabled: !_isLoading,
                    ),
                  ],
                ),
                _gap(),
              ],

              // ── SAVE BUTTON ───────────────────────────────────────────────
              ElevatedButton(
                onPressed: _isLoading ? null : _saveRule,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: AppColors.onPrimary,
                ),
                child: Text(
                  widget.isEditing ? l10n.updateRule : l10n.createRule,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reusable picker bottom-sheet widget.
// Owns its TextEditingController and working-list state so there is no
// use-after-dispose issue when the sheet animates away.
// ─────────────────────────────────────────────────────────────────────────────
class _PickerSheet extends StatefulWidget {
  final String title;
  final Map<String, String> options;
  final List<String> initialSelected;
  final bool isLoading;
  final String searchHint;
  final String doneLabel;
  final String emptyLabel;
  /// When true, shows the option key as a subtitle (useful for net options).
  final bool showSubtitle;
  /// When true, tapping an item immediately selects it and closes the sheet
  /// (radio-button behaviour). The Done button is hidden.
  final bool singleSelect;
  final ValueChanged<List<String>> onDone;

  const _PickerSheet({
    required this.title,
    required this.options,
    required this.initialSelected,
    required this.isLoading,
    required this.searchHint,
    required this.doneLabel,
    required this.emptyLabel,
    required this.showSubtitle,
    required this.onDone,
    this.singleSelect = false,
  });

  @override
  State<_PickerSheet> createState() => _PickerSheetState();
}

class _PickerSheetState extends State<_PickerSheet> {
  late final TextEditingController _searchCtrl;
  late List<String> _working;

  @override
  void initState() {
    super.initState();
    _searchCtrl = TextEditingController();
    _working = List<String>.from(widget.initialSelected);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchCtrl.text.toLowerCase();
    final filtered = widget.options.entries
        .where((e) =>
            e.key.toLowerCase().contains(query) ||
            e.value.toLowerCase().contains(query))
        .toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      expand: false,
      builder: (_, scrollCtrl) => Column(
        children: [
          // Handle bar
          const SizedBox(height: 8),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              widget.title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: widget.searchHint,
                prefixIcon: const Icon(Icons.search),
                isDense: true,
                border: const OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          Expanded(
            child: widget.isLoading
                ? const Center(child: CircularProgressIndicator())
                : widget.options.isEmpty
                    ? Center(child: Text(widget.emptyLabel))
                    : ListView.builder(
                        controller: scrollCtrl,
                        itemCount: filtered.length,
                        itemBuilder: (_, i) {
                          final e = filtered[i];
                          final isSelected = _working.contains(e.key);
                          if (widget.singleSelect) {
                            return ListTile(
                              dense: true,
                              selected: isSelected,
                              leading: Icon(
                                isSelected
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_unchecked,
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : null,
                              ),
                              title: Text(e.value),
                              subtitle: widget.showSubtitle && e.key != e.value
                                  ? Text(e.key,
                                      style: Theme.of(context).textTheme.bodySmall)
                                  : null,
                              onTap: () {
                                widget.onDone([e.key]);
                                Navigator.of(context).pop();
                              },
                            );
                          }
                          return CheckboxListTile(
                            dense: true,
                            value: isSelected,
                            title: Text(e.value),
                            subtitle: widget.showSubtitle && e.key != e.value
                                ? Text(e.key,
                                    style:
                                        Theme.of(context).textTheme.bodySmall)
                                : null,
                            onChanged: (v) => setState(() {
                              if (v == true) {
                                if (e.key == 'any') {
                                  _working
                                    ..clear()
                                    ..add('any');
                                } else {
                                  _working.remove('any');
                                  _working.add(e.key);
                                }
                              } else {
                                _working.remove(e.key);
                                if (_working.isEmpty) _working.add('any');
                              }
                            }),
                          );
                        },
                      ),
          ),
          if (!widget.singleSelect)
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      widget.onDone(List<String>.from(_working));
                      Navigator.of(context).pop();
                    },
                    child: Text(widget.doneLabel),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
