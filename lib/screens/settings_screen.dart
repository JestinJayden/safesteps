// ─── screens/settings_screen.dart ────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../services/ble_service.dart';
import '../widgets/bottom_nav.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _soundEnabled = true;
  bool _emergencyEnabled = true;
  bool _vibrateEnabled = true;
  bool _eveningMode = false;

  @override
  Widget build(BuildContext context) {
    final ble = context.watch<BleService>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.navy,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: const Text('Instellingen'),
      ),
      body: ListView(
        children: [
          // Profiel
          _SectionLabel('Profiel'),
          ListTile(
            leading: CircleAvatar(backgroundColor: AppTheme.navy, child: const Text('JD', style: TextStyle(color: Color(0xFF5DCAA5), fontSize: 13, fontWeight: FontWeight.w600))),
            title: const Text('Jan de Vries', style: TextStyle(fontSize: 13)),
            subtitle: const Text('jan@example.com', style: TextStyle(fontSize: 11)),
            trailing: const Icon(Icons.chevron_right, size: 18),
            onTap: () {},
          ),
          const Divider(height: 0.5, thickness: 0.5),

          // Telefoonnummer
          _SectionLabel('Telefoonnummer'),
          _SettingsRow(
            icon: Icons.phone_outlined,
            iconBg: const Color(0xFFE6F1FB),
            iconColor: const Color(0xFF0C447C),
            title: 'Telefoonnummer',
            subtitle: '+31 6 12345678',
            trailing: const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
            onTap: () {},
          ),

          // Geluid
          _SectionLabel('Geluid'),
          _SettingsRow(
            icon: Icons.volume_up_outlined,
            iconBg: AppTheme.greenLight,
            iconColor: const Color(0xFF085041),
            title: 'Geluidsmelding',
            subtitle: 'Geluid aan bij zone-overgang',
            trailing: Switch(value: _soundEnabled, onChanged: (v) => setState(() => _soundEnabled = v), activeColor: AppTheme.navy),
          ),
          _SettingsRow(
            icon: Icons.nightlight_outlined,
            iconBg: const Color(0xFFEEEDFE),
            iconColor: const Color(0xFF3C3489),
            title: 'Avondmodus',
            subtitle: 'Strengere routes na 19:00',
            trailing: Switch(value: _eveningMode, onChanged: (v) => setState(() => _eveningMode = v), activeColor: AppTheme.navy),
          ),

          // Noodgeval
          _SectionLabel('Help en noodgeval'),
          _SettingsRow(
            icon: Icons.sos_outlined,
            iconBg: AppTheme.redLight,
            iconColor: const Color(0xFF791F1F),
            title: 'Help noodgeval',
            subtitle: 'Noodknop stuurt locatie naar contact',
            trailing: Switch(value: _emergencyEnabled, onChanged: (v) => setState(() => _emergencyEnabled = v), activeColor: AppTheme.navy),
          ),

          // Armband
          _SectionLabel('Armband'),
          _SettingsRow(
            icon: Icons.bluetooth,
            iconBg: const Color(0xFFE6F1FB),
            iconColor: const Color(0xFF0C447C),
            title: 'Armband koppelen',
            subtitle: ble.statusMessage,
            trailing: ble.isConnected
                ? const Icon(Icons.check_circle, color: Color(0xFF1D9E75), size: 20)
                : TextButton(
                    onPressed: () => ble.startScan(),
                    child: const Text('Koppelen', style: TextStyle(fontSize: 12)),
                  ),
            onTap: ble.isConnected ? null : () => ble.startScan(),
          ),
          _SettingsRow(
            icon: Icons.vibration,
            iconBg: const Color(0xFFEEEDFE),
            iconColor: const Color(0xFF3C3489),
            title: 'Trilsignaal armband',
            subtitle: 'Trilt bij drukkere zone',
            trailing: Switch(value: _vibrateEnabled, onChanged: (v) => setState(() => _vibrateEnabled = v), activeColor: AppTheme.navy),
          ),

          // Noodcontact
          _SectionLabel('Noodcontact'),
          _SettingsRow(
            icon: Icons.person_outline,
            iconBg: AppTheme.amberLight,
            iconColor: const Color(0xFF633806),
            title: 'Naamcontactpersoon',
            subtitle: 'Wordt gebeld bij noodknop (1x drukken)',
            trailing: const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
            onTap: () {},
          ),

          const SizedBox(height: 20),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 3),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(14, 14, 14, 4),
    child: Text(label.toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey.shade500, letterSpacing: 0.5)),
  );
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final Color iconBg, iconColor;
  final String title, subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  const _SettingsRow({
    required this.icon, required this.iconBg, required this.iconColor,
    required this.title, required this.subtitle, required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          leading: Container(
            width: 34, height: 34,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(9)),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          title: Text(title, style: const TextStyle(fontSize: 13)),
          subtitle: Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
          trailing: trailing,
          onTap: onTap,
        ),
        const Divider(height: 0.5, thickness: 0.5, indent: 62),
      ],
    );
  }
}
