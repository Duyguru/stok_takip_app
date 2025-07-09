from celery import Celery
from app import crud, database, models
from sqlalchemy.orm import Session
import time
from app.notifications import send_notification

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
    user = db.query(models.User).filter(models.User.id == product.user_id).first()
    for size in product.tracked_sizes:
        # Simülasyon: rastgele stok değişimi
        import random
        prev_in_stock = size.in_stock
        new_in_stock = random.choice([True, False])
        if not prev_in_stock and new_in_stock:
            # Bildirim fonksiyonu çağrılacak
            if user:
                send_notification(user.email, product.url, size.size)
        size.in_stock = new_in_stock
    db.commit()
    db.close()

# Ürün silindiğinde arka plan görevini durdurmak için
scheduled_tasks = {}

def schedule_stock_check(product_id: int):
    # 15 dakikada bir tekrar eden görev (simülasyon için 60 sn yapılabilir)
    task = check_product_stock.apply_async((product_id,), countdown=900)
    scheduled_tasks[product_id] = task.id

def stop_stock_check(product_id: int):
    task_id = scheduled_tasks.get(product_id)
    if task_id:
        celery_app.control.revoke(task_id, terminate=True)
        scheduled_tasks.pop(product_id, None) 