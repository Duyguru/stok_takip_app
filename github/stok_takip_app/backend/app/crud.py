from sqlalchemy.orm import Session
from . import models, schemas

def get_user(db: Session, user_id: int):
    return db.query(models.User).filter(models.User.id == user_id).first()

def get_user_by_email(db: Session, email: str):
    return db.query(models.User).filter(models.User.email == email).first()

def create_user(db: Session, user: schemas.UserCreate):
    db_user = models.User(fcm_token=getattr(user, 'fcm_token', None))
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user

# Kullanıcının FCM token'ını güncelle

def update_user_fcm_token(db, user_id: int, fcm_token: str):
    user = db.query(models.User).filter(models.User.id == user_id).first()
    if user:
        user.fcm_token = fcm_token
        db.commit()
        db.refresh(user)
    return user

def create_product(db: Session, product: schemas.ProductCreate, user_id: int):
    db_product = models.Product(url=product.url, user_id=user_id)
    db.add(db_product)
    db.commit()
    db.refresh(db_product)
    for size in product.tracked_sizes:
        db_size = models.TrackedSize(size=size.size, in_stock=size.in_stock, product_id=db_product.id)
        db.add(db_size)
    db.commit()
    return db_product

def get_products(db: Session, user_id: int):
    return db.query(models.Product).filter(models.Product.user_id == user_id).all()

def delete_product(db: Session, product_id: int):
    product = db.query(models.Product).filter(models.Product.id == product_id).first()
    if product:
        # İlişkili bedenleri sil
        db.query(models.TrackedSize).filter(models.TrackedSize.product_id == product_id).delete()
        db.delete(product)
        db.commit()
        return True
    return False 