# Backend API Test Rehberi

## FastAPI'yi Başlatma

Backend klasöründe:

```
uvicorn app.main:app --reload
```

## Kullanıcı Oluşturma

```
curl -X POST "http://127.0.0.1:8000/users/" -H "Content-Type: application/json" -d '{"email": "test2@example.com"}'
```

## Ürün Ekleme (Kullanıcıya)

```
curl -X POST "http://127.0.0.1:8000/users/1/products/" -H "Content-Type: application/json" -d '{"url": "https://www.trendyol.com/urun/456", "tracked_sizes": [{"size": "S"}, {"size": "M"}]}'
```

## Kullanıcının Ürünlerini Listeleme

```
curl "http://127.0.0.1:8000/users/1/products/"
```

## Celery ile Arka Plan Görevleri

1. Redis kurulu ve çalışıyor olmalı (varsayılan: redis://localhost:6379/0)
2. Celery worker başlatmak için:

```
celery -A app.tasks.celery_app worker --loglevel=info
```

3. FastAPI uygulamasını başlatmak için:

```
uvicorn app.main:app --reload
```

Arka planda ürün stok kontrolü ve bildirimler Celery ile yönetilir.

## Notlar
- API dökümantasyonuna otomatik olarak http://127.0.0.1:8000/docs adresinden ulaşabilirsin.
- Test için Postman veya benzeri araçlar da kullanılabilir. 