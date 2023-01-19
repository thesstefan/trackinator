from __future__ import annotations
from flask_sqlalchemy import SQLAlchemy
from typing import Dict
import flask


db = SQLAlchemy()


class Movie(db.Model):
    __tablename__ = 'movies'

    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(256))
    dateWatched = db.Column(db.String(256))
    imageUrl = db.Column(db.String(256))
    notes = db.Column(db.String(256))
    rating = db.Column(db.Integer())

    def __init__(self, title: str, dateWatched: str, 
                 imageUrl: str, notes: str, rating: int) -> None:
        self.title = title
        self.dateWatched = dateWatched
        self.imageUrl = imageUrl
        self.notes = notes
        self.rating = rating

    def to_json(self):
        return {
            'id': self.id,
            'title': self.title,
            'imageUrl': self.imageUrl,
            'dateWatched': self.dateWatched,
            'notes': self.notes,
            'rating': self.rating
        }

    @staticmethod
    def fromJson(json: Dict[str, str]) -> Movie:
        return Movie(
            json['title'],
            json['dateWatched'],
            json['imageUrl'],
            json['notes'],
            int(json['rating'])
        )
