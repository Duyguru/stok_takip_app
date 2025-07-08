from pydantic import BaseModel
from typing import List, Optional

class TrackedSizeBase(BaseModel):
    size: str
    in_stock: Optional[bool] = False

class TrackedSizeCreate(TrackedSizeBase):
    pass

class TrackedSize(TrackedSizeBase):
    id: int
    class Config:
        orm_mode = True

class ProductBase(BaseModel):
    url: str

class ProductCreate(ProductBase):
    tracked_sizes: List[TrackedSizeCreate]

class Product(ProductBase):
    id: int
    tracked_sizes: List[TrackedSize] = []
    class Config:
        orm_mode = True

class UserBase(BaseModel):
    email: str

class UserCreate(UserBase):
    pass

class User(UserBase):
    id: int
    products: List[Product] = []
    class Config:
        orm_mode = True 