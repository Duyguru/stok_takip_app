from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List, Optional

app = FastAPI(title="Stok Takip API")

# Mock veri yapısı
products_db = []

class Product(BaseModel):
    id: int
    url: str
    name: Optional[str] = None
    sizes: List[str] = []
    tracked_sizes: List[str] = []

@app.get("/products", response_model=List[Product])
def list_products():
    return products_db

@app.post("/products", response_model=Product)
def add_product(product: Product):
    for p in products_db:
        if p.id == product.id:
            raise HTTPException(status_code=400, detail="Product already exists.")
    products_db.append(product)
    return product

@app.delete("/products/{product_id}")
def delete_product(product_id: int):
    global products_db
    products_db = [p for p in products_db if p.id != product_id]
    return {"message": "Product deleted."}
