from app import models, database
from sqlalchemy.orm import Session

def add_example_data():
    db = database.SessionLocal()
    # Eğer zaten varsa tekrar ekleme
    if db.query(models.User).filter_by(email="test@example.com").first():
        db.close()
        return
    user = models.User(email="test@example.com")
    db.add(user)
    db.commit()
    db.refresh(user)
    product = models.Product(url="https://www.trendyol.com/urun/123", user_id=user.id)
    db.add(product)
    db.commit()
    db.refresh(product)
    size1 = models.TrackedSize(size="M", in_stock=False, product_id=product.id)
    size2 = models.TrackedSize(size="L", in_stock=True, product_id=product.id)
    db.add_all([size1, size2])
    db.commit()
    db.close()

if __name__ == "__main__":
    add_example_data() 