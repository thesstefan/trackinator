package mobile.tracktinator.ui.details

import android.app.AlertDialog
import android.app.DatePickerDialog
import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.*
import androidx.fragment.app.activityViewModels
import androidx.navigation.fragment.findNavController
import mobile.tracktinator.R
import mobile.tracktinator.model.MovieRepository
import java.util.*
import kotlin.math.roundToInt

class DetailFragment() : Fragment() {
    companion object {
        fun newInstance() = DetailFragment()
    }

    private var movieId: Int = -1
    private val movieRepository: MovieRepository by activityViewModels()

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_detail, container, false)
    }

    private fun setDateEditListener() {
        val dateEdit = view!!.findViewById<TextView>(R.id.add_edit_date)
        dateEdit.setOnClickListener {
            val calendar = Calendar.getInstance()

            val year = calendar.get(Calendar.YEAR)
            val month = calendar.get(Calendar.MONTH)
            val day = calendar.get(Calendar.DAY_OF_MONTH)

            val datePickerDialog = DatePickerDialog(
                context!!,
                {
                        _, year, monthOfYear, dayOfMonth ->
                    dateEdit.text = "$dayOfMonth.$monthOfYear.$year"
                },
                year,
                month,
                day
            )

            datePickerDialog.show()
        }
    }

    private fun setUpdateListener() {
        val updateButton = view!!.findViewById<Button>(R.id.add_button)

        val title = view!!.findViewById<EditText>(R.id.add_edit_title)
        val date = view!!.findViewById<EditText>(R.id.add_edit_date)
        val note = view!!.findViewById<EditText>(R.id.add_edit_notes)
        val rating = view!!.findViewById<RatingBar>(R.id.add_rating)

        updateButton.setOnClickListener {
            movieRepository.updateMovie(movieId,
                title.text.toString(),
                rating.rating.roundToInt(),
                date.text.toString(),
                note.text.toString(),
                null)

            findNavController().popBackStack()
        }
    }

    private fun setDeleteListener() {
        val deleteButton = view!!.findViewById<Button>(R.id.detail_delete_button)

        deleteButton.setOnClickListener {
            val builder = AlertDialog.Builder(this@DetailFragment.context)
            builder.setMessage("Are you sure you want to delete this movie?")
                .setCancelable(false)
                .setPositiveButton("Yes") { _, _ ->
                    movieRepository.deleteMovie(movieId)

                    findNavController().popBackStack()
                }
                .setNegativeButton("No")  { dialog, _ ->
                    dialog.dismiss()
                }

            val alert = builder.create()
            alert.show()
        }
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        setDateEditListener()
        setUpdateListener()
        setDeleteListener()

        movieId = arguments!!.getInt("movieId")
        val movie = movieRepository.getById(movieId)

        val title = view.findViewById<EditText>(R.id.add_edit_title)
        val date = view.findViewById<EditText>(R.id.add_edit_date)
        val note = view.findViewById<EditText>(R.id.add_edit_notes)
        val rating = view.findViewById<RatingBar>(R.id.add_rating)
        val image = view.findViewById<ImageView>(R.id.add_cover_image)

        title.setText(movie.title)
        date.setText(movie.dateWatched)
        note.setText(movie.notes)
        rating.rating = movie.rating.toFloat()

        val drawableId = "@drawable/${movie.imageUrl}"
        val resource = resources.getIdentifier(drawableId, null, view.context.packageName)
        val drawable = view.context.getDrawable(resource)
        image.setImageDrawable(drawable)
    }
}