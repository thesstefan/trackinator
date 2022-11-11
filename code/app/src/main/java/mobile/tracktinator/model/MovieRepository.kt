package mobile.tracktinator.model

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import mobile.tracktinator.data.Datasource

class MovieRepository : ViewModel() {
    private val movieList = MutableLiveData<MutableList<Movie>>(Datasource().movies)
    private var id = 10

    fun getById(movieId: Int) : Movie {
        return movieList.value!!.first { movie -> movie.id == movieId }
    }

    fun deleteMovie(movieId: Int) {
        movieList.value!!.removeIf { movie -> movie.id == movieId }
    }

    fun getMovieAtIndex(index: Int): Movie {
        return movieList.value!![index]
    }

    fun loadMovies() : List<Movie> {
        return movieList.value!!
    }

    fun addMovie(title: String,
                 rating: Int,
                 notes: String,
                 dateWatched: String,
                 imageUrl: String) {
        id += 1
        movieList.value!!.add(
            Movie(id,
                title = title,
                rating = rating,
                notes = notes,
                dateWatched = dateWatched,
                imageUrl = imageUrl))
    }

    fun updateMovie(movieId: Int,
                    title: String,
                    rating: Int,
                    dateWatched: String,
                    notes: String,
                    imageUrl: String?) {
        val movie = movieList.value!!.findLast { movie -> movie.id == movieId } !!
        movie.title = title
        movie.rating = rating
        movie.notes = notes
        movie.dateWatched = dateWatched

        if (imageUrl != null)
            movie.imageUrl = imageUrl
    }

    fun size(): Int {
        return movieList.value!!.size
    }
}