# 🚀 ZNAL AI APK - Setup & Deploy Guide

## **⚡ SUPER CEPAT (5 Menit)**

---

## **STEP 1: Prepare Files**

```bash
1. Buat folder di laptop: znal-ai-flutter
2. Di dalam folder, buat struktur:

znal-ai-flutter/
├── lib/
│   └── main.dart          (Copy file gue)
├── pubspec.yaml           (Copy file gue)
├── android/
│   ├── app/
│   │   ├── build.gradle
│   │   └── src/
│   └── build.gradle
├── ios/
├── web/
├── windows/
├── macos/
├── linux/
└── .github/
    └── workflows/
        └── build-apk.yml  (Copy file gue)
```

---

## **STEP 2: GitHub Setup**

### **A. Buat Repository**
```
1. Login GitHub: https://github.com
2. Click "New Repository"
3. Nama: znal-ai
4. Pilih: Public
5. Click "Create Repository"
```

### **B. Clone Repository**
```bash
cd Desktop
git clone https://github.com/[USERNAME]/znal-ai.git
cd znal-ai
```

### **C. Buat Flutter Project Structure**
```bash
flutter create .
```

---

## **STEP 3: Copy Files Gue**

```bash
1. Copy main.dart ke: lib/main.dart
2. Copy pubspec.yaml ke: pubspec.yaml
3. Copy build-apk.yml ke: .github/workflows/build-apk.yml
```

---

## **STEP 4: Edit Config**

### **pubspec.yaml**
- Change app name if needed
- Verify dependencies

### **main.dart**
- **Line ~110** → Ganti `YOUR_CIORA_API_KEY` dengan API key lo dari ciora.my.id

**Contoh:**
```dart
final String cioraApiKey = 'sk-proj-xxxxxxxxxxxxx'; // Ganti di sini
```

---

## **STEP 5: Push ke GitHub**

```bash
git add .
git commit -m "Initial ZNAL AI commit"
git push origin main
```

---

## **STEP 6: GitHub Actions Auto-Build**

```
1. Buka: https://github.com/[USERNAME]/znal-ai
2. Klik tab "Actions"
3. Tunggu workflow "Build & Release APK" jalan
4. Tunggu ~5-10 menit sampai selesai ✅
```

---

## **STEP 7: Download APK**

```
1. Workflow selesai → Green checkmark ✅
2. Klik workflow yang selesai
3. Scroll down → "Artifacts"
4. Download: znal-ai-apk.zip
5. Extract → dapat znal-ai-[version].apk
```

---

## **STEP 8: Install di HP**

```
1. Pindahkan APK ke HP Bos (via USB/Cloud)
2. Buka File Manager → cari APK
3. Tap → Install
4. Open → ZNAL AI Jalan! 🎉
```

---

## **📋 QUICK CHECKLIST**

- [ ] Punya GitHub account?
- [ ] Clone repository?
- [ ] Copy 3 files (main.dart, pubspec.yaml, build-apk.yml)?
- [ ] Edit API key di main.dart?
- [ ] Git push ke GitHub?
- [ ] Tunggu GitHub Actions finish?
- [ ] Download APK?
- [ ] Install di HP?
- [ ] Test & selesai! 🚀

---

## **🆘 TROUBLESHOOTING**

### **GitHub Actions Failed?**
```
1. Cek tab "Actions"
2. Klik failed workflow
3. Lihat error message
4. Fix → Commit & push lagi
```

### **API Key Error?**
```
1. Pastikan API key dari ciora.my.id benar
2. Edit main.dart → line ~110
3. Simpan → Commit & push
4. GitHub Actions build ulang otomatis
```

### **APK Tidak Mau Install?**
```
1. HP butuh "Unknown Sources" enabled
2. Settings → Security → Unknown Sources → ON
3. Coba install lagi
```

---

## **📞 CONTOH FILE LENGKAP**

**Sudah disiapkan di:**
- ✅ pubspec.yaml
- ✅ main.dart
- ✅ build-apk.yml

**Tinggal follow step!** 🚀

---

## **🎯 SELESAI!**

Sekarang Bos punya:
- ✅ ZNAL AI APK
- ✅ Auto-build di GitHub Actions
- ✅ Semua fitur: Voice, Code Panel, File Gen, dll
- ✅ Siap deploy ke HP!

**Enjoy ZNAL AI! 💜**
