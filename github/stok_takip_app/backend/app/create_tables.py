from app import models, database

if __name__ == "__main__":
    models.Base.metadata.create_all(bind=database.engine)
    print("Tablolar oluşturuldu.") 