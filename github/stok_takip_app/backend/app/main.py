from fastapi import FastAPI
from app import routers, models, database

app = FastAPI()

app.include_router(routers.router)

@app.on_event("startup")
def on_startup():
    models.Base.metadata.create_all(bind=database.engine)

@app.get("/")
def read_root():
    return {"message": "Stok Takip API'ye hoş geldiniz!"} 