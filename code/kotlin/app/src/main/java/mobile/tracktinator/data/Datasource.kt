package mobile.tracktinator.data

import mobile.tracktinator.R
import mobile.tracktinator.model.Movie

class Datasource {
    val movies = arrayListOf(
        Movie(
            id = 1, title = "The Wolf of Wall Street", rating = 4,
            notes = "Good", dateWatched = "02.02.2020", imageUrl = "cover1"
        ),
        Movie(
            id = 2, title = "Titanic", rating = 3,
            notes = "A", dateWatched = "01.02.2020", imageUrl = "cover2"
        ),
        Movie(
            id = 3, title = "Forrest Gump", rating = 5,
            notes = "B", dateWatched = "01.02.2020", imageUrl = "cover3"
        ),
        Movie(
            id = 4, title = "Limitless", rating = 2,
            notes = "C", dateWatched = "01.02.2020", imageUrl = "cover4"
        ),
        Movie(
            id = 5, title = "The Great Gatsby", rating = 2,
            notes = "D", dateWatched = "01.02.2020", imageUrl = "placeholder"
        ),
        Movie(
            id = 6, title = "The Matrix", rating = 3,
            notes = "E", dateWatched = "01.02.2020", imageUrl = "placeholder"
        )
    )
}