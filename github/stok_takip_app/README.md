# Stok Takip Mobil Uygulaması

## Genel Bakış

Stok Takip, kullanıcıların Trendyol, Hepsiburada, Amazon, Pull&Bear, Zara, Bershka, Stradivarius, Koton gibi popüler e-ticaret sitelerinden ürün ekleyip, belirli beden ve renklerin stok durumunu otomatik olarak takip edebileceği bir mobil uygulamadır. Stokta olmayan beden/renk tekrar stoklara girdiğinde kullanıcıya **push bildirim** gönderir.

---

## Özellikler
- Ürün URL’si ekleyerek istediğin beden/renk için stok takibi
- Otomatik arka plan kontrolü (her 15 dakikada bir)
- Stok gelirse **push bildirim** (FCM ile)
- Bildirim ayarları: Sesli ve titreşimli mod
- Temiz ve modern Flutter arayüzü
- Desteklenen markalar:
  - Trendyol
  - Hepsiburada
  - Amazon
  - Pull&Bear
  - Zara
  - Bershka
  - Stradivarius
  - Koton

---

## Kurulum ve Başlatma

### 1. Backend (FastAPI) Kurulumu

```sh
cd backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```

> **Not:** Arka planda otomatik stok kontrolü ve bildirim için ayrıca Redis ve Celery gereklidir:
>
> ```sh
> brew services start redis
> celery -A app.tasks worker --loglevel=info
> ```

### 2. Frontend (Flutter) Kurulumu

```sh
cd frontend
flutter pub get
flutter run
```

> **Not:**
> - Android emülatörü kullanıyorsan API adresi otomatik olarak `10.0.2.2:8000` olarak ayarlanmıştır.
> - `frontend/android/app/google-services.json` dosyasını Firebase Console’dan indirip ilgili klasöre eklemelisin.

---

## Kullanım
1. Uygulamayı aç.
2. “Ürün Ekle” butonuna tıkla, takip etmek istediğin ürünün URL’sini ve beden/renk bilgisini gir.
3. Ürün eklendikten sonra ana ekranda görebilirsin.
4. Bildirim ayarlarından sesli ve titreşimli bildirim tercihini seçebilirsin.
5. Stokta olmayan beden/renk tekrar stoklara girerse, push bildirim alırsın.

---

## Teknik Gereksinimler
- Python 3.8+
- Redis (arka plan görevleri için)
- Flutter 3.x
- Firebase projesi (push bildirim için)

---

## Lisans
MIT
