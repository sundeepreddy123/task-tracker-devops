from fastapi import FastAPI, Depends
from sqlalchemy.orm import Session
from database import SessionLocal, engine
from models import Task, Base

Base.metadata.create_all(bind=engine)

app = FastAPI(title="Task Tracker API")

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@app.post("/tasks")
def create_task(task: dict, db: Session = Depends(get_db)):
    new_task = Task(title=task["title"], status=task.get("status", "pending"))
    db.add(new_task)
    db.commit()
    db.refresh(new_task)
    return new_task

@app.get("/tasks")
def list_tasks(db: Session = Depends(get_db)):
    return db.query(Task).all()
