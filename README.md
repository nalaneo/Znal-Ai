# 💜 ZNAL AI - Advanced Chatbot APK

Aplikasi Android chatbot canggih dengan voice chat, code panel, file generation, dan AI thinking mode.

---

## **✨ FITUR UTAMA**

- 🎤 **Voice Chat** - Bicara ke ZNAL AI, dia mengerti
- 💬 **100 Chat/Hari** - Free limit untuk user
- 💻 **Code Panel** - Generate & edit code dengan syntax highlighting
- 📄 **File Generation** - Buat PDF, Excel, Word otomatis
- 🧠 **Thinking Mode** - Lihat proses berpikir AI step-by-step
- 🔄 **Retry & Regenerate** - Coba 6x kalau tidak puas
- ⚡ **API Ciora** - Powered by Ciora AI
- 📱 **Mobile First** - UI design mirip ChatGPT
- 🎨 **Purple-Pink Theme** - Aesthetic modern design

---

## **🚀 SETUP CEPAT (5 Menit)**

### **Cara 1: Download APK Langsung (Termudah)**

```
1. Buka: https://github.com/NalaNeo/znal-ai/releases
2. Download APK terbaru
3. Install di HP
4. Done! 🎉
```

### **Cara 2: Build Sendiri via GitHub**

**Requirements:**
- GitHub account
- Ciora API key (dari https://ciora.my.id)

**Steps:**

```bash
# 1. Clone repo
git clone https://github.com/[USERNAME]/znal-ai.git
cd znal-ai

# 2. Edit config
nano lib/main.dart
# Cari: final String cioraApiKey = 'YOUR_CIORA_API_KEY'
# Ganti dengan API key lo

# 3. Push ke GitHub
git add .
git commit -m "Setup ZNAL AI"
git push origin main

# 4. GitHub Actions auto-build APK
# 5. Download dari Releases
```

---

## **📋 FILE STRUKTUR**

```
znal-ai/
├── lib/
│   └── main.dart                 # Main app logic
├── android/
│   └── app/
│       └── src/main/AndroidManifest.xml  # Permissions
├── pubspec.yaml                  # Dependencies
├── .github/
│   └── workflows/
│       └── build-apk.yml        # GitHub Actions config
└── README.md                     # This file
```

---

## **⚙️ KONFIGURASI**

### **API Key Ciora**

Edit `lib/main.dart` line ~110:

```dart
final String cioraApiKey = 'YOUR_CIORA_API_KEY';
// Ganti dengan API key dari https://ciora.my.id
```

### **Daily Limit**

Edit `lib/main.dart` line ~50:

```dart
int dailyLimit = 100; // Ganti angkanya kalau perlu
```

---

## **📱 FITUR DETAIL**

### **Voice Chat**
- Tap 🎤 icon → berbicara
- Otomatis recognize bahasa Indonesia & English
- Langsung kirim hasil transcribe ke AI

### **Code Panel**
- AI generate code → auto-highlight syntax
- Support: Python, JavaScript, Java, C++, PHP, dll
- Copy code dengan 1 tap

### **File Generation**
- Generate PDF, Excel (.xlsx), Word (.docx)
- Direct download ke Storage HP
- Template support (invoice, report, etc)

### **Thinking Mode**
- Tap "🧠 Proses" → lihat langkah-langkah AI
- Step-by-step reasoning visible
- Transparent AI decision making

### **Plus Menu (+)**
- 📷 Kamera - scan document
- 🖼️ Foto - upload image
- 📁 File - upload file
- 🌐 Web Search - search internet
- 💾 Memory - app memory notes
- 🔧 Tools - akses alat-alat

---

## **🎯 PENGGUNAAN**

### **Chat Normal**
```
1. Ketik pertanyaan di input field
2. Tap tombol send (✈️)
3. Tunggu response
4. Lihat 🧠 Proses kalau mau
5. Tap 🔄 Ulangi kalau tidak puas
```

### **Voice Chat**
```
1. Tap 🎤 icon
2. Bicara jelas ke mic
3. Tunggu transcribe selesai
4. Hasil otomatis terkirim
5. AI balas dengan suara
```

### **Generate File**
```
Chat: "Bikin invoice dengan item A, B, C"
AI: Generate PDF invoice
Tap: Download
Selesai!
```

---

## **📥 INSTALASI**

### **Android (APK)**

```
1. Download APK dari Releases
2. HP: Settings → Security → Unknown Sources (ON)
3. Buka APK → Tap Install
4. Open → Start using!
```

### **Requirements**
- Android 5.0+ (API 21+)
- ~100 MB storage
- Internet connection

---

## **🐛 TROUBLESHOOTING**

### **"Koneksi Gagal"**
```
❌ Cek: Pastikan internet aktif
✅ Fix: Matikan WiFi → coba data
```

### **"API Key Invalid"**
```
❌ Cek: API key dari ciora.my.id
✅ Fix: Edit main.dart → hapus spasi → push & rebuild
```

### **"APK Corrupt"**
```
❌ Cek: Download ulang dari releases
✅ Fix: Verify SHA256 checksum
```

### **"Microphone Not Working"**
```
❌ Cek: Settings → App Permissions → Microphone (ON)
✅ Fix: Restart app
```

---

## **🔐 PRIVACY & SECURITY**

- ✅ API key disimpan di app local storage
- ✅ Chat history hanya di device (tidak cloud)
- ✅ Tidak ada server tracking
- ✅ Tidak ada ads atau analytics
- ✅ Open source (cek kode sendiri)

---

## **🤝 KONTRIBUSI**

Issues? PRs? Suggestions?

```
1. Fork repository
2. Create feature branch
3. Commit changes
4. Push & create PR
5. Tunggu review
```

---

## **📄 LISENSI**

MIT License - Bebas modifikasi & distribute

---

## **📞 SUPPORT**

- **Issues:** https://github.com/NalaNeo/znal-ai/issues
- **Discussions:** https://github.com/NalaNeo/znal-ai/discussions
- **Email:** support@nalaneo.dev

---

## **🎉 CHANGELOG**

### **v1.0.0** (First Release)
- ✅ Voice chat
- ✅ Code panel
- ✅ File generation
- ✅ Thinking mode
- ✅ 100 chat/day limit
- ✅ Beautiful UI

---

**Enjoy ZNAL AI! 💜**

**Made with ❤️ by NalaNeo**

---

## **⭐ Jangan Lupa Star!**

Kalau suka, jangan lupa star repo ini di GitHub! ⭐⭐⭐

```
https://github.com/NalaNeo/znal-ai
```
