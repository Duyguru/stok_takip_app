from sqlalchemy import Column, Integer, String, ForeignKey, Boolean
from sqlalchemy.orm import relationship, declarative_base

Base = declarative_base()

class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    fcm_token = Column(String, nullable=True)
    products = relationship("Product", back_populates="user")

class Product(Base):
    __tablename__ = "products"
    id = Column(Integer, primary_key=True, index=True)
    url = Column(String, index=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    user = relationship("User", back_populates="products")
    tracked_sizes = relationship("TrackedSize", back_populates="product")

class TrackedSize(Base):
    __tablename__ = "tracked_sizes"
    id = Column(Integer, primary_key=True, index=True)
    product_id = Column(Integer, ForeignKey("products.id"))
    size = Column(String)
    in_stock = Column(Boolean, default=False)
    product = relationship("Product", back_populates="tracked_sizes") 