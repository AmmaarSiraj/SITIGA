import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cobabps/MenuNav/profil_bps.dart';
import 'package:cobabps/MenuNav/profil_developer.dart';

class LainnyaNavScreen extends StatefulWidget {
  final void Function(int) onTap;

  const LainnyaNavScreen({Key? key, required this.onTap}) : super(key: key);

  @override
  State<LainnyaNavScreen> createState() => _LainnyaNavScreenState();
}

class _LainnyaNavScreenState extends State<LainnyaNavScreen> {
  bool isTentangKamiExpanded = false;
  String selectedItem = ''; // Track selected item

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildIconItem(String key, IconData icon, String title, VoidCallback onTap,
      {EdgeInsetsGeometry? margin}) {
    final isSelected = selectedItem == key;

    return Container(
      margin: margin,
      child: ListTile(
        leading: Icon(icon, color: isSelected ? Colors.blue : Colors.black),
        title: Text(
          title,
          style: TextStyle(color: isSelected ? Colors.blue : Colors.black),
        ),
        onTap: () {
          setState(() {
            selectedItem = key;
          });
          onTap();
        },
      ),
    );
  }

  Widget _buildImageItem(String key, String assetPath, String title, VoidCallback onTap) {
    final isSelected = selectedItem == key;

    return ListTile(
      leading: Image.asset(assetPath, width: 24, height: 24),
      title: Text(
        title,
        style: TextStyle(color: isSelected ? Colors.blue : Colors.black),
      ),
      onTap: () {
        setState(() {
          selectedItem = key;
        });
        onTap();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Lainnya",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Berita
              _buildIconItem('berita', Icons.newspaper, 'Berita', () {
                widget.onTap(4);
                Navigator.pop(context);
              }),

              // Dataku
              _buildIconItem('dataku', Icons.person, 'Dataku', () {
                Navigator.pop(context);
              }),

              // Tentang Kami
              ListTile(
                leading: Icon(Icons.info,
                    color: isTentangKamiExpanded ? Colors.blue : Colors.black),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Tentang Kami",
                        style: TextStyle(
                            color: isTentangKamiExpanded ? Colors.blue : Colors.black),
                      ),
                    ),
                    Icon(
                      isTentangKamiExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                    ),
                  ],
                ),
                onTap: () {
                  setState(() {
                    isTentangKamiExpanded = !isTentangKamiExpanded;
                  });
                },
              ),

              if (isTentangKamiExpanded) ...[
                _buildIconItem('profil_bps', Icons.account_balance, 'Profil BPS', () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilBPSPage(),
                    ),
                  );
                }, margin: const EdgeInsets.only(left: 32)),
                _buildIconItem('profil_dev', Icons.code, 'Profil Developer', () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilDeveloperPage(),
                    ),
                  );
                }, margin: const EdgeInsets.only(left: 32)),
              ],

              const Divider(),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Sosial Media",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

              _buildImageItem('Facebook', 'assets/images/facebook.png', "BPS Kota Salatiga", () {
                _launchUrl('https://www.facebook.com/bpskotasalatiga');
                Navigator.pop(context);
              }),
              _buildImageItem('Twitter', 'assets/images/twitter.png', "@bps_statistics", () {
                _launchUrl('https://x.com/bps_statistics');
                Navigator.pop(context);
              }),
              _buildImageItem('Instagram', 'assets/images/instagram.png', "@bpskotasalatiga1", () {
                _launchUrl('https://www.instagram.com/bpskotasalatiga1/');
                Navigator.pop(context);
              }),
             
            ],
          ),
        ),
      ),
    );
  }
}
