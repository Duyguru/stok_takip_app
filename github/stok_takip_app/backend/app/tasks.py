from celery import Celery
from app import crud, database, models
from sqlalchemy.orm import Session
import time
from app.notifications import send_notification
import requests
from bs4 import BeautifulSoup

celery_app = Celery(
    'tasks',
    broker='redis://localhost:6379/0',
    backend='redis://localhost:6379/0'
)

# --- Scraping fonksiyon şablonları ---
def scrape_trendyol(url, size, color=None):
    # TODO: Trendyol ürün sayfasından stok kontrolü
    # requests ve BeautifulSoup ile HTML parse et
    # İlgili beden/renk için stok durumunu döndür (True/False)
    return False

def scrape_hepsiburada(url, size, color=None):
    # TODO: Hepsiburada ürün sayfasından stok kontrolü
    return False

def scrape_amazon(url, size, color=None):
    # TODO: Amazon ürün sayfasından stok kontrolü
    return False

def scrape_pullandbear(url, size, color=None):
    # TODO: Pull&Bear ürün sayfasından stok kontrolü
    return False

def scrape_zara(url, size, color=None):
    # TODO: Zara ürün sayfasından stok kontrolü
    return False

def scrape_bershka(url, size, color=None):
    # TODO: Bershka ürün sayfasından stok kontrolü
    return False

def scrape_stradivarius(url, size, color=None):
    # TODO: Stradivarius ürün sayfasından stok kontrolü
    return False

def scrape_koton(url, size, color=None):
    # TODO: Koton ürün sayfasından stok kontrolü
    return False

# Siteye göre scraping fonksiyonu seçici
def get_scraper(url):
    if 'trendyol.com' in url:
        return scrape_trendyol
    if 'hepsiburada.com' in url:
        return scrape_hepsiburada
    if 'amazon.' in url:
        return scrape_amazon
    if 'pullandbear.com' in url:
        return scrape_pullandbear
    if 'zara.com' in url:
        return scrape_zara
    if 'bershka.com' in url:
        return scrape_bershka
    if 'stradivarius.com' in url:
        return scrape_stradivarius
    if 'koton.com' in url:
        return scrape_koton
    return None

@celery_app.task
def check_product_stock(product_id: int):
    db: Session = database.SessionLocal()
    product = db.query(models.Product).filter(models.Product.id == product_id).first()
    if not product:
        db.close()
        return
    user = db.query(models.User).filter(models.User.id == product.user_id).first()
    scraper = get_scraper(product.url)
    for size in product.tracked_sizes:
        prev_in_stock = size.in_stock
        # Gerçek scraping ile stok kontrolü
        if scraper:
            new_in_stock = scraper(product.url, size.size, getattr(size, 'color', None))
        else:
            new_in_stock = False  # Bilinmeyen site
        if not prev_in_stock and new_in_stock:
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