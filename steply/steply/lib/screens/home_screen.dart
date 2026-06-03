import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../services/ble_service.dart';
import '../widgets/gradient_background.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/steply_logo.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ble = context.watch<BleService>();

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: const AppBottomNav(currentIndex: 0),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 16),
            children: [
              const Text('Welkom terug.', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w700)),
              const Text('Maria', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text('Hoe wilt u vandaag wandelen?', style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14)),
              const SizedBox(height: 24),

              // Rustige wandeling (donker)
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/preferences'),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppTheme.navy, borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 12, offset: const Offset(0, 4))],
                  ),
                  child: Row(children: [
                    Container(width: 44, height: 44,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.directions_walk, color: Colors.white, size: 24)),
                    const SizedBox(width: 14),
                    const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Rustige wandeling', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                      SizedBox(height: 2),
                      Text('Wij kiezen een veilige route', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ])),
                    const Icon(Icons.chevron_right, color: Colors.white54),
                  ]),
                ),
              ),

              // Eigen bestemming kiezen (wit)
              WhiteCard(
                padding: const EdgeInsets.all(18),
                onTap: () => Navigator.pushNamed(context, '/map'),
                child: Row(children: [
                  Container(width: 44, height: 44,
                    decoration: BoxDecoration(color: AppTheme.cardGrey, borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.location_on_outlined, color: AppTheme.navy, size: 24)),
                  const SizedBox(width: 14),
                  const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Eigen bestemming kiezen', style: TextStyle(color: AppTheme.navy, fontSize: 16, fontWeight: FontWeight.w600)),
                    SizedBox(height: 2),
                    Text('Kies zelf waar u naartoe wilt', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ])),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ]),
              ),

              // Armband kaart met echte watch
              WhiteCard(
                padding: const EdgeInsets.all(16),
                child: Row(children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Armband', style: TextStyle(color: AppTheme.navy, fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Row(children: [
                      Icon(Icons.check_circle, color: ble.isConnected ? AppTheme.green : Colors.grey, size: 16),
                      const SizedBox(width: 5),
                      Text(ble.isConnected ? 'Verbonden' : 'Niet verbonden',
                        style: TextStyle(color: ble.isConnected ? AppTheme.green : Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
                    ]),
                    const SizedBox(height: 6),
                    Row(children: [
                      const Icon(Icons.battery_5_bar, color: AppTheme.green, size: 16),
                      const SizedBox(width: 5),
                      Text('${ble.battery}%', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ]),
                  ])),
                  const SteplyWatch(height: 80),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
