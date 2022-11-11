package mobile.tracktinator.ui.dashboard

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.fragment.app.activityViewModels
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.RecyclerView
import mobile.tracktinator.R
import mobile.tracktinator.adapter.ItemAdapter
import mobile.tracktinator.databinding.FragmentDashboardBinding
import mobile.tracktinator.model.MovieRepository

class DashboardFragment : Fragment() {

    private var _binding: FragmentDashboardBinding? = null
    private val movieRepository: MovieRepository by activityViewModels()

    // This property is only valid between onCreateView and
    // onDestroyView.
    private val binding get() = _binding!!

    override fun onCreateView(
            inflater: LayoutInflater,
            container: ViewGroup?,
            savedInstanceState: Bundle?
    ): View {
        val view = inflater.inflate(R.layout.fragment_dashboard, container, false)
        val recyclerView = view.findViewById<RecyclerView>(R.id.recycler_view)

        recyclerView.adapter = ItemAdapter(container!!.context, movieRepository)

        return view;
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}