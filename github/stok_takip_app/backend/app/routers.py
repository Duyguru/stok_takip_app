from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from . import crud, schemas, models, database
from .tasks import schedule_stock_check

router = APIRouter()

def get_db():
    db = database.SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/users/", response_model=schemas.User)
def create_user(user: schemas.UserCreate, db: Session = Depends(get_db)):
    db_user = crud.get_user_by_email(db, email=user.email)
    if db_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    return crud.create_user(db=db, user=user)

@router.post("/users/{user_id}/products/", response_model=schemas.Product)
def create_product_for_user(user_id: int, product: schemas.ProductCreate, db: Session = Depends(get_db)):
    new_product = crud.create_product(db=db, product=product, user_id=user_id)
    schedule_stock_check(new_product.id)
    return new_product

@router.get("/users/{user_id}/products/", response_model=list[schemas.Product])
def read_products(user_id: int, db: Session = Depends(get_db)):
    return crud.get_products(db, user_id=user_id) 