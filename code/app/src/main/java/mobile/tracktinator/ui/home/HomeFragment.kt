package mobile.tracktinator.ui.home

import android.app.DatePickerDialog
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.*
import androidx.fragment.app.Fragment
import androidx.fragment.app.activityViewModels
import androidx.navigation.fragment.findNavController
import mobile.tracktinator.R
import mobile.tracktinator.databinding.FragmentHomeBinding
import mobile.tracktinator.model.MovieRepository
import java.util.*
import kotlin.math.roundToInt

class HomeFragment : Fragment() {

    private var _binding: FragmentHomeBinding? = null
    private val movieRepository: MovieRepository by activityViewModels()

    // This property is only valid between onCreateView and
    // onDestroyView.
    private val binding get() = _binding!!

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _binding = FragmentHomeBinding.inflate(inflater, container, false)

        return binding.root
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
                { _, year, monthOfYear, dayOfMonth ->
                    dateEdit.text = "$dayOfMonth.$monthOfYear.$year"
                },
                year,
                month,
                day
            )

            datePickerDialog.show()
        }
    }

   override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        setDateEditListener()

        var addButton = view.findViewById<Button>(R.id.add_button)
        addButton.setOnClickListener {
            val title = view.findViewById<EditText>(R.id.add_edit_title)
            val date = view.findViewById<EditText>(R.id.add_edit_date)
            val note = view.findViewById<EditText>(R.id.add_edit_notes)
            val rating = view.findViewById<RatingBar>(R.id.add_rating)

            movieRepository.addMovie(
                title.text.toString(),
                rating.rating.roundToInt(),
                note.text.toString(),
                date.text.toString(),
                "placeholder"
            )

            findNavController().navigate(R.id.navigation_dashboard)
        }
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}