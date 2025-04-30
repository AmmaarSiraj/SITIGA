import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cobabps/news/news_list_screen.dart';
import 'package:cobabps/MenuNav/profil_bps.dart';
import 'package:cobabps/MenuNav/profil_developer.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      decoration: const BoxDecoration(
        color: Color.fromARGB(20, 218, 217, 217),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.table_view_sharp, "Tabel", 2),
          _buildNavItem(Icons.image, "Infografis", 1),
          _buildNavItem(Icons.home, "Beranda", 0, isCenter: true),
          _buildNavItem(Icons.article, "Publikasi", 3),
          _buildMoreNavItem(context),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index,
      {bool isCenter = false}) {
    final bool isActive = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isActive
                  ? const Color.fromARGB(255, 101, 149, 153)
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 24,
              color: isActive
                  ? Colors.white
                  : const Color.fromARGB(255, 45, 67, 69),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 10,
              color: isActive
                  ? const Color.fromARGB(255, 45, 67, 69)
                  : const Color.fromARGB(255, 40, 40, 40),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoreNavItem(BuildContext context) {
    final bool isActive = currentIndex == 4; // Set index 4 untuk "Lainnya"
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) => MoreMenu(
            currentIndex: currentIndex,
            onTap: onTap,
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isActive
                  ? const Color.fromARGB(255, 101, 149, 153)
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.menu,
              size: 24,
              color: isActive
                  ? Colors.white
                  : const Color.fromARGB(255, 45, 67, 69),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Lainnya",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 10,
              color: isActive
                  ? const Color.fromARGB(255, 45, 67, 69)
                  : const Color.fromARGB(255, 40, 40, 40),
            ),
          ),
        ],
      ),
    );
  }
}

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

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

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
      ),
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
                  widget.onTap(4); // Set index 4 untuk aktifkan tombol "Lainnya"
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewsListScreen()),
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
              const Divider(),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Sosial Media",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
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
            ],
          ),
        ),
      ),
    );
  }
}
