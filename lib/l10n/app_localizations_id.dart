// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Luna POS';

  @override
  String get appTagline => 'Taglinemu di sini';

  @override
  String get home => 'Beranda';

  @override
  String get tasks => 'Tugas';

  @override
  String get calendar => 'Kalender';

  @override
  String get messages => 'Pesan';

  @override
  String get profile => 'Profil';

  @override
  String get overview => 'Ringkasan';

  @override
  String get recentActivity => 'Aktivitas Terbaru';

  @override
  String get viewAll => 'Lihat semua';

  @override
  String get themeColor => 'Warna Tema';

  @override
  String get language => 'Bahasa';

  @override
  String greeting(String name) {
    return 'Selamat pagi, $name';
  }

  @override
  String get haveAGreatDay => 'Semoga harimu menyenangkan!';

  @override
  String get welcomeBack => 'Selamat Datang Kembali';

  @override
  String get signInToContinue => 'Masuk untuk melanjutkan ke akunmu';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'contoh@email.com';

  @override
  String get password => 'Kata Sandi';

  @override
  String get passwordHint => 'Masukkan kata sandimu';

  @override
  String get forgotPassword => 'Lupa kata sandi?';

  @override
  String get login => 'Masuk';

  @override
  String get orContinueWith => 'atau lanjut dengan';

  @override
  String get google => 'Google';

  @override
  String get apple => 'Apple';

  @override
  String get dontHaveAccount => 'Belum punya akun? ';

  @override
  String get register => 'Daftar';

  @override
  String get createAccount => 'Buat Akun';

  @override
  String get signUpToGetStarted => 'Daftar untuk memulai';

  @override
  String get fullName => 'Nama Lengkap';

  @override
  String get fullNameHint => 'John Doe';

  @override
  String get confirmPassword => 'Konfirmasi Kata Sandi';

  @override
  String get alreadyHaveAccount => 'Sudah punya akun? ';

  @override
  String get signIn => 'Masuk';

  @override
  String get settings => 'Pengaturan';

  @override
  String get myProfile => 'Profil Saya';

  @override
  String get achievements => 'Pencapaian';

  @override
  String get activityHistory => 'Riwayat Aktivitas';

  @override
  String get savedItems => 'Item Tersimpan';

  @override
  String get projects => 'Proyek';

  @override
  String get completed => 'Selesai';

  @override
  String get account => 'Akun';

  @override
  String get personalInformation => 'Informasi Pribadi';

  @override
  String get security => 'Keamanan';

  @override
  String get notifications => 'Notifikasi';

  @override
  String get privacy => 'Privasi';

  @override
  String get preferences => 'Preferensi';

  @override
  String get appearance => 'Tampilan';

  @override
  String get darkMode => 'Mode Gelap';

  @override
  String get about => 'Tentang';

  @override
  String get logout => 'Keluar';

  @override
  String get english => 'Inggris';

  @override
  String get fieldRequired => 'Bidang ini wajib diisi';

  @override
  String get invalidEmail => 'Masukkan alamat email yang valid';

  @override
  String get passwordTooShort => 'Kata sandi minimal 6 karakter';

  @override
  String get passwordsDoNotMatch => 'Kata sandi tidak cocok';

  @override
  String get menu => 'Menu';

  @override
  String get refreshMenu => 'Muat ulang menu';

  @override
  String get noMenuItemsAvailable => 'Tidak ada item menu tersedia';

  @override
  String get retry => 'Coba lagi';

  @override
  String get checkout => 'Checkout';

  @override
  String get payment => 'Pembayaran';

  @override
  String get confirm => 'Konfirmasi';

  @override
  String get complete => 'Selesai';

  @override
  String get amountDue => 'Jumlah tagihan';

  @override
  String get cashReceived => 'Uang diterima';

  @override
  String get change => 'Kembalian';

  @override
  String get insufficientPayment => 'Pembayaran kurang';

  @override
  String get paymentSuccess => 'Pembayaran berhasil';

  @override
  String get grandTotal => 'Total keseluruhan';

  @override
  String get quantityLabel => 'Jml';

  @override
  String get noteLabel => 'Catatan';

  @override
  String get unitPrice => 'Harga satuan';

  @override
  String get lineTotal => 'Total baris';

  @override
  String get noNote => '—';

  @override
  String get printer => 'Printer';

  @override
  String get bluetoothStatus => 'Bluetooth';

  @override
  String get bluetoothOn => 'Aktif';

  @override
  String get bluetoothOff => 'Nonaktif';

  @override
  String get printerConnectionStatus => 'Printer';

  @override
  String get connected => 'Terhubung';

  @override
  String get disconnected => 'Terputus';

  @override
  String get connecting => 'Menghubungkan…';

  @override
  String get scanPairedPrinters => 'Pindai printer yang dipasangkan';

  @override
  String get noPairedPrintersPlaceholder =>
      'Tidak ada printer yang dipasangkan. Pasangkan printer di pengaturan Bluetooth Android, lalu pindai lagi.';

  @override
  String get testPrint => 'Cetak uji';

  @override
  String get cart => 'Keranjang';

  @override
  String get addToCart => 'Tambah ke keranjang';

  @override
  String get add => 'Tambah';

  @override
  String get orderTotal => 'Total pesanan';

  @override
  String get emptyCart => 'Keranjangmu kosong';

  @override
  String get clearCart => 'Kosongkan keranjang';

  @override
  String get remove => 'Hapus';

  @override
  String itemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count item',
      one: '1 item',
      zero: 'Tidak ada item',
    );
    return '$_temp0';
  }

  @override
  String get editNote => 'Ubah catatan';

  @override
  String get noteHint => 'Catatan opsional (mis. es sedikit)';

  @override
  String get saleComplete => 'Penjualan selesai';

  @override
  String saleCompleteMessage(String amount) {
    return 'Kembalian: $amount';
  }

  @override
  String get ok => 'OK';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get discount => 'Diskon';

  @override
  String get total => 'Total';

  @override
  String get proceed => 'Lanjutkan';

  @override
  String get printReceipt => 'Cetak struk';

  @override
  String get printAgain => 'Cetak ulang';

  @override
  String get printFailedWarning =>
      'Struk tidak dapat dicetak. Anda dapat mencoba lagi atau melanjutkan.';

  @override
  String get invalidDiscount => 'Diskon tidak boleh melebihi subtotal';

  @override
  String transactionIdLabel(String id) {
    return 'ID Transaksi: $id';
  }

  @override
  String get transactionHistory => 'Riwayat';

  @override
  String get transactionDetails => 'Detail transaksi';

  @override
  String get noTransactions => 'Belum ada transaksi';

  @override
  String get paymentMethod => 'Pembayaran';

  @override
  String get paymentMethodOffline => 'Tunai';

  @override
  String get cashier => 'Kasir';

  @override
  String get filterByDate => 'Filter tanggal';

  @override
  String get clearDateFilter => 'Hapus filter tanggal';

  @override
  String get notAuthorized => 'Tidak diizinkan';

  @override
  String get notAuthorizedMessage =>
      'Anda tidak memiliki izin untuk melihat transaksi. Silakan keluar dan gunakan akun kasir.';
}
