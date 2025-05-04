import 'package:flutter/material.dart';
<<<<<<< HEAD
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
=======
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main_screen.dart';
import 'package:cobabps/MenuNav/profil_bps.dart';
import 'package:cobabps/MenuNav/profil_developer.dart';

class MoreMenu extends StatefulWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const MoreMenu({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  State<MoreMenu> createState() => _MoreMenuState();
}

class _MoreMenuState extends State<MoreMenu> {
  bool isTentangKamiExpanded = false;
>>>>>>> 6848fdb5d042b3187a6ab30d123ccc3dbf5f0965

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

<<<<<<< HEAD
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
=======
  Widget _buildMenuItem(Widget icon, String title, VoidCallback onTap,
      {EdgeInsetsGeometry? margin}) {
    return Container(
      margin: margin,
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 101, 149, 153),
            shape: BoxShape.circle,
          ),
          child: Center(child: icon),
        ),
        title: Text(title),
        onTap: onTap,
>>>>>>> 6848fdb5d042b3187a6ab30d123ccc3dbf5f0965
      ),
    );
  }

<<<<<<< HEAD
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

=======
>>>>>>> 6848fdb5d042b3187a6ab30d123ccc3dbf5f0965
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
<<<<<<< HEAD
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
=======
              Row(
                children: [
                  const Text(
                    "Lainnya",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildMenuItem(
                const Icon(Icons.newspaper, color: Colors.white, size: 20),
                "Berita",
                () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (_) => MainScreen(initialIndex: 4)),
                    (route) => false,
                  );
                },
              ),
              _buildMenuItem(
                const Icon(Icons.cloud, color: Colors.white, size: 20),
                "Dataku",
                () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 101, 149, 153),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.info_outline,
                        color: Colors.white, size: 20),
                  ),
                ),
                title: Row(
                  children: [
                    const Expanded(child: Text("Tentang Kami")),
>>>>>>> 6848fdb5d042b3187a6ab30d123ccc3dbf5f0965
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
<<<<<<< HEAD

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

=======
              if (isTentangKamiExpanded) ...[
                _buildMenuItem(
                  const Icon(Icons.account_balance,
                      color: Colors.white, size: 20),
                  "Profil BPS",
                  () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfilBPSPage(),
                      ),
                    );
                  },
                  margin: const EdgeInsets.only(left: 32),
                ),
                _buildMenuItem(
                  const Icon(Icons.person, color: Colors.white, size: 20),
                  "Profil Developer",
                  () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfilDeveloperPage(),
                      ),
                    );
                  },
                  margin: const EdgeInsets.only(left: 32),
                ),
              ],
>>>>>>> 6848fdb5d042b3187a6ab30d123ccc3dbf5f0965
              const Divider(),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Sosial Media",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
<<<<<<< HEAD

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
             
=======
              _buildMenuItem(
                const FaIcon(FontAwesomeIcons.facebook,
                    color: Colors.white, size: 20),
                "Facebook",
                () {
                  Navigator.pop(context);
                  _launchUrl('https://www.facebook.com/bpskotasalatiga');
                },
              ),
              _buildMenuItem(
                const FaIcon(FontAwesomeIcons.xTwitter,
                    color: Colors.white, size: 20),
                "X (Twitter)",
                () {
                  Navigator.pop(context);
                  _launchUrl('https://x.com/bps_statistics');
                },
              ),
              _buildMenuItem(
                const FaIcon(FontAwesomeIcons.instagram,
                    color: Colors.white, size: 20),
                "Instagram",
                () {
                  Navigator.pop(context);
                  _launchUrl('https://www.instagram.com/bpskotasalatiga1/');
                },
              ),
              _buildMenuItem(
                const FaIcon(FontAwesomeIcons.youtube,
                    color: Colors.white, size: 20),
                "YouTube",
                () {
                  Navigator.pop(context);
                  _launchUrl('https://www.youtube.com/c/BPSKotaSalatiga');
                },
              ),
>>>>>>> 6848fdb5d042b3187a6ab30d123ccc3dbf5f0965
            ],
          ),
        ),
      ),
    );
  }
}
