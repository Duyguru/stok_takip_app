from fastapi import FastAPI
from app import routers

app = FastAPI()

app.include_router(routers.router)

@app.get("/")
def read_root():
    return {"message": "Stok Takip API'ye hoş geldiniz!"} 