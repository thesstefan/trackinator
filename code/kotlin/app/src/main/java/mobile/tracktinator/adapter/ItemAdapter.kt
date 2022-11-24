package mobile.tracktinator.adapter

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.View.OnClickListener
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.RatingBar
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.core.os.bundleOf
import androidx.navigation.fragment.findNavController
import androidx.recyclerview.widget.RecyclerView
import mobile.tracktinator.R
import mobile.tracktinator.model.MovieRepository

class ItemAdapter(private val context: Context,
                  private val dataset: MovieRepository
)
    : RecyclerView.Adapter<ItemAdapter.ItemViewHolder>() {

    class ItemViewHolder(private val view: View) : RecyclerView.ViewHolder(view) {
        val textView: TextView = view.findViewById(R.id.movie_title)
        val rating: RatingBar = view.findViewById(R.id.movie_rating)
        val image: ImageView = view.findViewById(R.id.movie_cover_image)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ItemViewHolder {
        val adapterLayout = LayoutInflater.from(parent.context)
            .inflate(R.layout.movie_item, parent, false)

        return ItemViewHolder(adapterLayout)
    }

    override fun onBindViewHolder(holder: ItemViewHolder, position: Int) {
        val item = dataset.getMovieAtIndex(position)

        val onClickListener = OnClickListener {
            val fragmentManager = (context as AppCompatActivity).supportFragmentManager
            val navController = fragmentManager.primaryNavigationFragment!!.findNavController()

            val bundle = bundleOf("movieId" to item.id)
            navController.navigate(R.id.navigation_detail, bundle)
        }
        holder.itemView.setOnClickListener(onClickListener)

        val drawableId = "@drawable/${item.imageUrl}"
        val resource = context.resources.getIdentifier(drawableId, null, context.packageName)
        val drawable = context.getDrawable(resource)

        holder.textView.text = item.title
        holder.rating.rating = item.rating.toFloat()
        holder.image.setImageDrawable(drawable)
    }

    override fun getItemCount() : Int {
        return dataset.size()
    }
}