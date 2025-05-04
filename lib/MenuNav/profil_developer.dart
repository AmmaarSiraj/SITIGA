import 'package:flutter/material.dart';

class ProfilDeveloperPage extends StatelessWidget {
  const ProfilDeveloperPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil Developer"),
        backgroundColor: const Color.fromARGB(255, 101, 149, 153),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Halaman ini memperkenalkan tim developer yang telah berkontribusi dalam pembuatan aplikasi ini. "
                "Mereka terdiri dari mahasiswa berbakat yang memiliki spesialisasi di bidang pengembangan perangkat lunak dan desain antarmuka.",
                style: TextStyle(fontSize: 16, height: 1.6),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              _buildDeveloperProfile(
                name: "Annisa Padila",
                role: "Project Leader & Frontend Developer",
                description:
                    "Bertanggung jawab mengkoordinasikan proyek serta mengembangkan antarmuka aplikasi menggunakan Flutter.",
              ),
              const SizedBox(height: 16),
              _buildDeveloperProfile(
                name: "Bima Pradana",
                role: "Backend Developer",
                description:
                    "Mengembangkan API, mengelola server, serta integrasi data menggunakan teknologi berbasis Firebase dan REST API.",
              ),
              const SizedBox(height: 16),
              _buildDeveloperProfile(
                name: "Citra Maheswari",
                role: "UI/UX Designer",
                description:
                    "Mendesain pengalaman pengguna yang intuitif dan estetis untuk aplikasi melalui wireframe dan prototipe.",
              ),
              const SizedBox(height: 16),
              _buildDeveloperProfile(
                name: "Daffa Rizky",
                role: "Mobile Developer",
                description:
                    "Membantu dalam pengembangan dan pengujian aplikasi mobile pada berbagai perangkat Android.",
              ),
              const SizedBox(height: 16),
              _buildDeveloperProfile(
                name: "Eka Putri",
                role: "Quality Assurance",
                description:
                    "Bertugas melakukan pengujian aplikasi, menemukan bug, serta memastikan kualitas aplikasi sebelum rilis.",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeveloperProfile({
    required String name,
    required String role,
    required String description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          role,
          style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> 6848fdb5d042b3187a6ab30d123ccc3dbf5f0965
