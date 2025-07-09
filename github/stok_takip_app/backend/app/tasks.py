from celery import Celery
from app import crud, database, models
from sqlalchemy.orm import Session
import time

celery_app = Celery(
    'tasks',
    broker='redis://localhost:6379/0',
    backend='redis://localhost:6379/0'
)

@celery_app.task
def check_product_stock(product_id: int):
    db: Session = database.SessionLocal()
    product = db.query(models.Product).filter(models.Product.id == product_id).first()
    if not product:
        db.close()
        return
    # Burada gerçek stok kontrolü yapılacak (örnek: web scraping veya API)
    # Şimdilik simülasyon: tracked_sizes içindeki in_stock değerini değiştir
    for size in product.tracked_sizes:
        # Simülasyon: rastgele stok değişimi
        import random
        prev_in_stock = size.in_stock
        new_in_stock = random.choice([True, False])
        if not prev_in_stock and new_in_stock:
            # Bildirim fonksiyonu çağrılacak
            print(f"[BILDIRIM] {product.url} - {size.size} tekrar stokta!")
        size.in_stock = new_in_stock
    db.commit()
    db.close()

# Ürün eklendiğinde bu fonksiyonla periyodik görev başlatılır
def schedule_stock_check(product_id: int):
    # 15 dakikada bir tekrar eden görev (simülasyon için 60 sn yapılabilir)
    celery_app.add_periodic_task(900, check_product_stock.s(product_id)) 