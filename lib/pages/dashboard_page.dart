// Mengimpor pustaka material design Flutter untuk komponen antarmuka 
import 'package:flutter/material.dart'; 
// Mengimpor pustaka pemformat internasionalisasi (intl) untuk format angka & mata uang Rupiah 
import 'package:intl/intl.dart'; 
// Mengimpor model data dan daftar produk dummy dari folder models 
import '../models/produk.dart'; 
 
// Komponen/Widget DashboardPage turunan StatefulWidget: Memiliki state dinamis yang dapat berubah saat berinteraksi 
class DashboardPage extends StatefulWidget { 
  // Konstruktor konstan dengan parameter key 
  const DashboardPage({super.key}); 
 
  // Method createState: Menghubungkan widget antarmuka dengan kelas pengelola state internalnya 
  @override 
  State<DashboardPage> createState() => _DashboardPageState(); 
} 
 
// Kelas pengelola state dan logika bisnis tampilan halaman Dashboard Beranda 
class _DashboardPageState extends State<DashboardPage> { 
  // --- DEKLARASI VARIABEL STATE & KONFIGURASI TAMPILAN --- 
  // Deklarasi variabel indeks filter kategori yang sedang aktif (0: Semua, 1: Makanan, 2: Minuman, 3: Snack) 
  int _kategoriTerpilih = 0; 
 
  // Deklarasi variabel koleksi opsi filter kategori toko kasir (Tipe: List of String, Immutable) 
  final List<String> _kategoriList = ['Semua', 'Makanan', 'Minuman', 'Snack']; 
 
  // --- FUNGSI FORMAT MATA UANG RUPIAH --- 
  // Fungsi utilitas untuk mengonversi angka double menjadi string format mata uang standar Indonesia (Rp) 
  String _formatRupiah(double nominal) { 
    // Deklarasi variabel pemformat mata uang menggunakan pustaka NumberFormat 
    final formatCurrency = NumberFormat.currency( 
      locale: 'id_ID',      // Pengaturan lokal Indonesia (pemisah ribuan menggunakan titik) 
      symbol: 'Rp ',        // Simbol mata uang Indonesia 
      decimalDigits: 0,     // Jumlah angka di belakang koma (0 digit desimal) 
    ); 
    // Mengembalikan string angka terformat, contoh: 18000.0 menjadi "Rp 18.000" 
    return formatCurrency.format(nominal); 
  } 
 
  // --- FUNGSI PEMBUAT WIDGET BADGE INDIKATOR STOK (LOGIKA BISNIS KASIR) --- 
  // Fungsi helper untuk membangun widget badge stok dengan warna dan label adaptif sesuai sisa persediaan 
  Widget _buildBadgeStok(int stok) { 
    // Deklarasi variabel lokal penampung warna latar, warna teks, dan string label badge 
    Color warnaLatar; 
    Color warnaTeks; 
    String label; 
 
    // --- KONTROL PERCABANGAN / LOGIKA INDIKATOR PERSENYAAN STOK --- 
    // Percabangan Kondisi 1: Jika stok barang bernilai 0 (Habis Total) 
    if (stok == 0) { 
      warnaLatar = Colors.red.shade100;   // Latar belakang merah muda 
      warnaTeks = Colors.red.shade900;    // Teks merah pekat peringatan bahaya 
      label = 'Habis';                    // Label teks status kosong 
    } 
    // Percabangan Kondisi 2: Jika stok barang tersisa 1 hingga 5 unit (Persediaan Kritis/Menipis) 
    else if (stok <= 5) { 
      warnaLatar = Colors.amber.shade100; // Latar belakang kuning / oranye muda 
      warnaTeks = Colors.amber.shade900;  // Teks oranye gelap tanda waspada 
      label = 'Sisa $stok';               // Label interpolasi string menampilkan sisa unit 
    } 
    // Percabangan Kondisi 3: Jika stok barang lebih dari 5 unit (Persediaan Aman/Berlimpah) 
    else { 
      warnaLatar = Colors.green.shade100; // Latar belakang hijau muda 
      warnaTeks = Colors.green.shade900;  // Teks hijau pekat tanda persediaan aman 
      label = 'Stok $stok';               // Label interpolasi string menampilkan jumlah stok 
    } 
 
    // Komponen/Widget Container: Wadah kotak pembungkus badge dengan sudut melengkung 
    return Container( 
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), // Jarak bantalan dalam badge 
      decoration: BoxDecoration( 
        color: warnaLatar,                // Menerapkan warna latar hasil evaluasi percabangan logika 
        borderRadius: BorderRadius.circular(6), // Sudut kotak badge dibuat melengkung 6 piksel 
      ), 
      // Komponen/Widget Text: Menampilkan label status stok dengan penataan gaya 
      child: Text( 
        label,                          // Menerapkan teks label hasil evaluasi percabangan logika 
        style: TextStyle( 
          fontSize: 10,                   // Ukuran font teks badge: 10 pt 
          fontWeight: FontWeight.bold,    // Ketebalan font teks: Tebal (Bold) 
          color: warnaTeks,               // Menerapkan warna font hasil evaluasi percabangan logika 
        ), 
      ), 
    ); 
  } 
 
  // Method build: Merender seluruh hierarki antarmuka Dashboard saat halaman ditampilkan atau di-rebuild 
  @override 
  Widget build(BuildContext context) { 
    // --- KONTROL PERCABANGAN LOGIKA PENYARINGAN (FILTER) KATALOG PRODUK --- 
    // Menggunakan operator percabangan ternary (kondisi ? jika_benar : jika_salah) 
    final listTampil = _kategoriTerpilih == 0 
        ? daftarProdukDummy // Jika tombol "Semua" aktif (indeks 0), tampilkan seluruh 6 produk dummy 
        : daftarProdukDummy // Jika kategori spesifik dipilih, lakukan perulangan filter .where() 
            .where((p) => p.kategori == _kategoriList[_kategoriTerpilih]) 
            .toList(); // Mengonversi hasil penyaringan iterable kembali menjadi List<Produk> 
 
    // Komponen/Widget Scaffold: Menyediakan kerangka dasar halaman visual aplikasi 
    return Scaffold( 
      // Komponen/Widget AppBar: Bilah navigasi bagian atas halaman beranda 
      appBar: AppBar( 
        // Komponen/Widget Row: Menyusun ikon kasir dan teks nama aplikasi secara horisontal 
        title: const Row( 
          mainAxisSize: MainAxisSize.min, // Lebar baris menyesuaikan ukuran konten di dalamnya 
          children: [ 
            // Komponen/Widget Icon: Menampilkan simbol mesin kasir POS berwarna emas 
            Icon(Icons.point_of_sale, color: Colors.amber, size: 24), 
            SizedBox(width: 8),           // Komponen/Widget SizedBox: Memberi jarak spasi horizontal 8 piksel 
            // Komponen/Widget Text: Menampilkan teks judul nama aplikasi 
            Text( 
              'SmartKasir', 
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18), 
            ), 
          ], 
        ), 
        // Properti actions: Kumpulan tombol aksi interaktif di pojok kanan bilah AppBar 
        actions: [ 
          // Komponen/Widget IconButton: Tombol lonceng notifikasi operasional penjualan 
          IconButton( 
            tooltip: 'Notifikasi Penjualan', 
            icon: const Icon(Icons.notifications_none), 
            onPressed: () {},             // Aksi ketika tombol notifikasi ditekan (placeholder) 
          ), 
        ], 
      ), 
      // Komponen/Widget Column: Tata letak linier vertikal menyusun 3 blok utama dari atas ke bawah 
      body: Column( 
        children: [ 
          // ========================================================================= 
          // BLOK 1: BANNER RINGKASAN PENJUALAN TOKO HARI INI (OMZET KASIR) 
          // ========================================================================= 
          // Komponen/Widget Container: Kotak kartu ringkasan omzet dengan gradasi warna 
          Container( 
            margin: const EdgeInsets.all(12),   // Jarak luar kotak dari batas tepi layar (12 dp) 
            padding: const EdgeInsets.all(16),  // Jarak bantalan dalam dari tepi ke konten kartu (16 dp) 
            decoration: BoxDecoration( 
              // Gradasi warna linier dari Pink ke Pink Terang 
              gradient: const LinearGradient( 
                colors: [Color(0xFFE91E63), Color(0xFFF48FB1)], 
                begin: Alignment.topLeft, 
                end: Alignment.bottomRight, 
              ), 
              borderRadius: BorderRadius.circular(12), // Sudut kartu melengkung 12 piksel 
              boxShadow: [ 
                // Efek bayangan elevasi modern di bawah kartu omzet 
                BoxShadow( 
                  color: Colors.pink.withOpacity(0.25), 
                  blurRadius: 8, 
                  offset: const Offset(0, 4), 
                ), 
              ], 
            ), 
            // Komponen/Widget Row: Memisahkan teks omzet di sisi kiri dan badge transaksi di sisi kanan 
            child: Row( 
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Jarak renggang maksimal antar anak 
              children: [ 
                // Komponen/Widget Column: Menyusun label omzet dan nominal rupiah secara vertikal 
                Column( 
                  crossAxisAlignment: CrossAxisAlignment.start, // Meratakan teks ke batas kiri 
                  children: [ 
                    const Text( 
                      'Total Penjualan Hari Ini', 
                      style: TextStyle(color: Colors.white70, fontSize: 12), 
                    ), 
                    const SizedBox(height: 4),  // Jarak vertikal 4 piksel 
                    // Komponen/Widget Text: Menampilkan nominal omzet kasir terformat 
                    Text( 
                      _formatRupiah(845000),    // Memanggil fungsi format mata uang 
                      style: const TextStyle( 
                        color: Colors.white, 
                        fontSize: 22, 
                        fontWeight: FontWeight.bold, 
                      ), 
                    ), 
                  ], 
                ), 
                // Komponen/Widget Container: Kapsul penanda jumlah transaksi kasir yang telah berhasil 
                Container( 
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), 
                  decoration: BoxDecoration( 
                    color: Colors.white.withOpacity(0.2), // Latar semi-transparan elegan 
                    borderRadius: BorderRadius.circular(20), // Bentuk kapsul oval 
                  ), 
                  // Komponen/Widget Row: Ikon struk belanja berjajar dengan jumlah transaksi 
                  child: const Row( 
                    children: [ 
                      Icon(Icons.receipt_long, color: Colors.white, size: 16), 
                      SizedBox(width: 4),       // Spasi 4 piksel 
                      Text( 
                        '34 Transaksi', 
                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold), 
                      ), 
                    ], 
                  ), 
                ), 
              ], 
            ), 
          ), 
 
          // ========================================================================= 
          // BLOK 2: KONTROL PERULANGAN FILTER KATEGORI CEPAT (HORIZONTAL CHIPS) 
          // ========================================================================= 
          // Komponen/Widget SizedBox: Membatasi tinggi vertikal baris tombol filter horizontal (42 dp) 
          SizedBox( 
            height: 42, 
            // Komponen/Widget ListView.builder: PERULANGAN MEMBANGUN DAFTAR TOMBOL GESER HORIZONTAL 
            child: ListView.builder( 
              scrollDirection: Axis.horizontal,         // Arah gulir daftar: Menyamping/Horisontal 
              padding: const EdgeInsets.symmetric(horizontal: 12), // Bantalan kiri-kanan 
              itemCount: _kategoriList.length,          // KONTROL PERULANGAN: Batas loop sebanyak elemen list (4 item) 
              itemBuilder: (context, index) {           // KONTROL PERULANGAN: Fungsi loop mengiterasi setiap indeks (0..3) 
                // Deklarasi variabel boolean: Mengevaluasi apakah tombol kategori ini sedang aktif diklik 
                final isSelected = _kategoriTerpilih == index; 
 
                // Komponen/Widget Padding: Memberi jarak pemisah antar tombol filter 
                return Padding( 
                  padding: const EdgeInsets.only(right: 8), 
                  // Komponen/Widget FilterChip: Tombol interaktif penyaring kategori Material Design 3 
                  child: FilterChip( 
                    // Menampilkan label teks kategori dari variabel list pada indeks saat ini 
                    label: Text(_kategoriList[index]), 
                    selected: isSelected,                 // Status seleksi aktif/tidaknya tombol 
                    selectedColor: const Color(0xFFE91E63),// Warna latar belakang saat tombol terpilih (Pink) 
                    // KONTROL PERCABANGAN TAMPILAN TEKS FILTER: Putih jika aktif, hitam jika tidak aktif 
                    labelStyle: TextStyle( 
                      color: isSelected ? Colors.white : Colors.black87, 
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, 
                      fontSize: 12, 
                    ), 
                    // Event Handler saat tombol diklik oleh pengguna 
                    onSelected: (val) { 
                      // KONTROL LOGIKA STATE MANAGEMENT: Memperbarui variabel state dan memicu re-render 
                      setState(() { 
                        _kategoriTerpilih = index;       // Mengubah variabel indeks kategori aktif 
                      }); 
                    }, 
                  ), 
                ); 
              }, 
            ), 
          ), 
          const SizedBox(height: 8),                      // Jarak pemisah vertikal 8 piksel 
 
          // ========================================================================= 
          // BLOK 3: KONTROL PERULANGAN GRIDVIEW KATALOG PRODUK KASIR 2 KOLOM 
          // ========================================================================= 
          // Komponen/Widget Expanded: Memastikan area katalog memenuhi sisa ruang layar ke bawah 
          Expanded( 
            // KONTROL PERCABANGAN TAMPILAN: Jika hasil filter kosong, tampilkan teks pemberitahuan 
            child: listTampil.isEmpty 
                ? const Center(child: Text('Tidak ada produk pada kategori ini')) 
                // Komponen/Widget GridView.builder: PERULANGAN MEMBANGUN KARTU PRODUK 2 KOLOM RESPONSIF 
                : GridView.builder( 
                    padding: const EdgeInsets.all(12),    // Jarak luar kisi katalog dari tepi layar 
                    // Delegasi konfigurasi tata letak kisi (Grid Layout Configuration) 
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount( 
                      crossAxisCount: 2,                  // Membagi baris menjadi tepat 2 kolom kartu 
                      childAspectRatio: 0.90,             // Rasio lebar:tinggi 0.90 agar batas bawah kartu pas di bawah harga 
                      crossAxisSpacing: 12,               // Jarak renggang horizontal antar kolom (12 dp) 
                      mainAxisSpacing: 12,                // Jarak renggang vertikal antar baris kartu (12 dp) 
                    ), 
                    itemCount: listTampil.length,         // KONTROL PERULANGAN: Jumlah kartu dibangun sebanyak item listTampil 
                    itemBuilder: (context, index) {       // KONTROL PERULANGAN: Membangun kartu produk ke-index secara dinamis 
                      // Deklarasi variabel lokal objek produk yang sedang diproses pada perulangan saat ini 
                      final produk = listTampil[index]; 
 
                      // Komponen/Widget Card: Kartu pembungkus informasi produk dengan efek bayangan 
                      return Card( 
                        elevation: 2,                     // Ketinggian bayangan kartu produk 
                        shape: RoundedRectangleBorder( 
                          borderRadius: BorderRadius.circular(10), // Sudut kartu melengkung 10 piksel 
                        ), 
                        clipBehavior: Clip.antiAlias,     // Memotong konten kartu agar rapi mengikuti lekukan sudut 
                        child: Column( 
                          crossAxisAlignment: CrossAxisAlignment.start, // Meratakan teks info ke kiri 
                          children: [ 
                            // ------------------------------------------------------------- 
                            // BAGIAN 1: FOTO PRODUK + BADGE PROMO DISKON (STACK OVERLAY) 
                            // ------------------------------------------------------------- 
                            // Komponen/Widget Stack: Menumpuk badge promo diskon tepat di atas foto produk 
                            Stack( 
                              children: [ 
                                // Komponen/Widget Image.network: Memuat foto produk langsung dari URL internet 
                                Image.network( 
                                  produk.gambarUrl, 
                                  height: 125,            // Tinggi gambar produk diseragamkan tepat 125 piksel 
                                  width: double.infinity, // Lebar gambar memenuhi seluruh lebar kartu 
                                  fit: BoxFit.cover,      // Skala gambar proporsional memenuhi area tanpa distorsi 
                                  // Indikator visual ketika gambar sedang proses diunduh dari jaringan 
                                  loadingBuilder: (context, child, loadingProgress) { 
                                    if (loadingProgress == null) return child; // Gambar selesai diunduh 
                                    return Container( 
                                      height: 125, 
                                      color: Colors.grey.shade200, 
                                      child: const Center( 
                                        child: SizedBox( 
                                          width: 24, 
                                          height: 24, 
                                          child: CircularProgressIndicator(strokeWidth: 2), 
                                        ), 
                                      ), 
                                    ); 
                                  }, 
                                  // Tampilan fallback pengganti jika koneksi internet terputus atau URL gagal dimuat 
                                  errorBuilder: (context, error, stackTrace) => Container( 
                                    height: 125, 
                                    color: Colors.grey.shade300, 
                                    child: const Center( 
                                      child: Icon(Icons.broken_image, color: Colors.grey, size: 36), 
                                    ), 
                                  ), 
                                ), 
 
                                // --- KONTROL PERCABANGAN LOGIKA BADGE PROMO DISKON --- 
                                // Percabangan Logika: Hanya tampilkan badge jika atribut diskonPersen > 0 
                                if (produk.diskonPersen > 0) 
                                  // Komponen/Widget Positioned: Mengunci posisi badge promo di pojok kiri atas foto 
                                  Positioned( 
                                    top: 6, 
                                    left: 6, 
                                    child: Container( 
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), 
                                      decoration: BoxDecoration( 
                                        color: Colors.red.shade700, // Warna merah menyala untuk promo diskon 
                                        borderRadius: BorderRadius.circular(4), 
                                      ), 
                                      child: Text( 
                                        'PROMO ${produk.diskonPersen}%', // Interpolasi string nilai diskon 
                                        style: const TextStyle( 
                                          color: Colors.white, 
                                          fontSize: 9, 
                                          fontWeight: FontWeight.bold, 
                                        ), 
                                      ), 
                                    ), 
                                  ), 
                              ], 
                            ), 
 
                            // ------------------------------------------------------------- 
                            // BAGIAN 2: INFORMASI NAMA, STOK, DAN HARGA PRODUK 
                            // ------------------------------------------------------------- 
                            // Komponen/Widget Padding: Memberi jarak bantalan yang rapat & presisi 
                            Padding( 
                              padding: const EdgeInsets.fromLTRB(8, 6, 8, 8), 
                              child: Column( 
                                crossAxisAlignment: CrossAxisAlignment.start, 
                                mainAxisSize: MainAxisSize.min, // Ukuran kolom pas mengikuti tinggi konten 
                                children: [ 
                                  // Komponen/Widget Text: Menampilkan nama barang dagangan 
                                  Text( 
                                    produk.nama, 
                                    maxLines: 1,                // Dibatasi maksimal 1 baris 
                                    overflow: TextOverflow.ellipsis, // Jika panjang, dipotong dengan tanda titik tiga (...) 
                                    style: const TextStyle( 
                                      fontWeight: FontWeight.bold, 
                                      fontSize: 13, 
                                    ), 
                                  ), 
                                  const SizedBox(height: 3),      // Jarak spasi rapat 3 piksel 
                                  // Memanggil fungsi logika pembuat badge stok dinamis (Hijau/Kuning/Merah) 
                                  _buildBadgeStok(produk.stok), 
                                  const SizedBox(height: 3),      // Jarak pas langsung ke baris harga di bawahnya 
 
                                  // Komponen/Widget Row: Memisahkan label harga di kiri dan tombol tambah di kanan 
                                  Row( 
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                                    children: [ 
                                      // Komponen/Widget Text: Menampilkan harga jual produk dalam format Rupiah 
                                      Text( 
                                        _formatRupiah(produk.harga), 
                                        style: TextStyle( 
                                          color: Colors.pink.shade900, 
                                          fontWeight: FontWeight.bold, 
                                          fontSize: 13, 
                                        ), 
                                      ), 
                                      // Komponen/Widget InkWell: Area sentuh tombol aksi kasir dengan efek riak (ripple) 
                                      InkWell( 
                                        // --- KONTROL PERCABANGAN LOGIKA PROTEKSI TRANSAKSI KASIR --- 
                                        // Percabangan Logika: Jika stok habis (0), aksi onTap dinonaktifkan (null) 
                                        // agar kasir tidak dapat menambahkan barang kosong ke keranjang belanja! 
                                        onTap: produk.stok == 0 ? null : () {}, 
                                        borderRadius: BorderRadius.circular(15), 
                                        // Komponen/Widget CircleAvatar: Tombol bulat ikon tambah (+) 
                                        child: CircleAvatar( 
                                          radius: 14, 
                                          // KONTROL PERCABANGAN WARNA TOMBOL: Abu-abu jika habis, Pink jika tersedia 
                                          backgroundColor: produk.stok == 0 
                                              ? Colors.grey.shade300 
                                              : const Color(0xFFE91E63), 
                                          child: const Icon( 
                                            Icons.add, 
                                            color: Colors.white, 
                                            size: 16, 
                                          ), 
                                        ), 
                                      ), 
                                    ], 
                                  ), 
                                ], 
                              ), 
                            ), 
                          ], 
                        ), 
                      ); 
                    }, 
                  ), 
          ), 
        ], 
      ), 
    ); 
  } 
}