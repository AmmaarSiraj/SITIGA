import 'package:flutter/material.dart';

class ProfilBPSPage extends StatelessWidget {
  const ProfilBPSPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil BPS Kota Salatiga"),
        backgroundColor: const Color.fromARGB(255, 101, 149, 153),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // JUDUL BARU DITAMBAHKAN DI SINI
              Center(
                child: Column(
                  children: const [
                    Text(
                      "BPS KOTA SALATIGA",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
              const Text(
                "Badan Pusat Statistik (BPS) adalah Lembaga Pemerintah Non-Kementerian yang bertanggung jawab langsung kepada Presiden. "
                "Awalnya bernama Biro Pusat Statistik berdasarkan UU No. 6 Tahun 1960 dan UU No. 7 Tahun 1960, kemudian berubah menjadi BPS melalui UU No. 16 Tahun 1997 tentang Statistik. "
                "Undang-undang ini juga membagi statistik menjadi statistik dasar, statistik sektoral, dan statistik khusus. BPS berperan penting dalam menyediakan data untuk pemerintah dan masyarakat "
                "melalui sensus, survei, dan pengumpulan data sekunder. Selain itu, BPS mengembangkan sistem statistik nasional, metodologi statistik, pendidikan dan pelatihan statistik, serta menjalin kerja sama internasional. "
                "Publikasi rutin BPS dilakukan melalui Berita Resmi Statistik (BRS).",
                style: TextStyle(fontSize: 16, height: 1.6),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 16),
              const Text(
                "Sejarah kegiatan statistik di Indonesia bermula pada masa Hindia Belanda dengan pendirian Centraal Kantoor Voor De Statistiek (CKS) di Bogor pada 1920, yang kemudian memindahkan aktivitasnya ke Jakarta dan melakukan Sensus Penduduk pertama pada 1930. "
                "Pada masa pendudukan Jepang, CKS berganti nama menjadi Shomubu Chosasitsu Gunseikanbu. Pasca-kemerdekaan, lembaga ini dinasionalisasi menjadi Kantor Penyelidikan Perangkaan Umum Republik Indonesia (KAPPURI), "
                "kemudian dilebur menjadi Kantor Pusat Statistik (KPS), dan bertransformasi menjadi Biro Pusat Statistik lewat Keputusan Presiden No. 172 Tahun 1957. Sensus Penduduk pertama setelah kemerdekaan dilakukan pada 1961. "
                "Struktur BPS pusat dan daerah terus diperkuat melalui berbagai regulasi, termasuk pembentukan Kantor Statistik Provinsi dan Kabupaten/Kotamadya, hingga akhirnya mengalami transformasi besar pada 19 Mei 1997 melalui pengesahan "
                "UU No. 16 Tahun 1997 serta pengaturan organisasi daerah dengan Keputusan Presiden No. 86 Tahun 1998 dan PP No. 51 Tahun 1999.",
                style: TextStyle(fontSize: 16, height: 1.6),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              const Text(
                "Alamat dan Kontak BPS Kota Salatiga",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Alamat Kantor: Jl. Hasanudin km 01, Dukuh, Salatiga 50722",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                "Telepon: (0298) 326319",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                "E-Mail: bps3373@bps.go.id",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                "WhatsApp: 0896 3303 0002 (chat only)",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                "Website: https://salatigakota.bps.go.id/",
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
