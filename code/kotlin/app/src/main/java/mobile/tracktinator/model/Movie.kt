package mobile.tracktinator.model

data class Movie(
    var id: Int,
    var dateWatched: String,
    var title: String,
    var imageUrl: String,
    var notes: String,
    var rating: Int)