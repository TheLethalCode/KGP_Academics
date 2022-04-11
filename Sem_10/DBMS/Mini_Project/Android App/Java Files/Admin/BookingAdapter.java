package com.example.admin;
import android.content.Context;
//import android.support.v7.widget.RecyclerView;
import android.content.Intent;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import androidx.recyclerview.widget.RecyclerView;

import com.android.volley.AuthFailureError;
import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.bumptech.glide.Glide;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class BookingAdapter extends RecyclerView.Adapter<BookingAdapter.ProductViewHolder>  {


    private Context mCtx;
    private List<Booking> productList;

    public BookingAdapter(Context mCtx, List<Booking> productList) {
        this.mCtx = mCtx;
        this.productList = productList;
    }

    @Override
    public ProductViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        LayoutInflater inflater = LayoutInflater.from(mCtx);
        View view = inflater.inflate(R.layout.booking_list, null);
        return new ProductViewHolder(view);
    }

    @Override
    public void onBindViewHolder(ProductViewHolder holder, final int position) {
        final Booking product = productList.get(position);

        //loading the image
//        Glide.with(mCtx)
//                .load(product.getImage())
//                .into(holder.imageView);
        holder.event_id.setText(String.valueOf(product.getevent_id()));
        holder.name.setText(product.getname());
        holder.roomNo.setText(product.getroomNo());
        holder.building.setText(product.getbuilding());
        holder.auth.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(final View v) {
                final String  event_id = String.valueOf(productList.get(position).getevent_id());

                StringRequest stringRequest = new StringRequest(Request.Method.POST,
                        Constants.URL_AUTHENTICATE,
                        new Response.Listener<String>() {
                            @Override
                            public void onResponse(String response) {
//                        progressDialog.dismiss();
                                Log.i("tagconvertstr", "["+response+"]");
                                try {
                                    JSONObject jsonObject = new JSONObject(response);

                                    Toast.makeText(v.getContext(), jsonObject.getString("message"), Toast.LENGTH_LONG).show();

                                } catch (JSONException e) {
                                    e.printStackTrace();
                                }
                            }
                        },
                        new Response.ErrorListener() {
                            @Override
                            public void onErrorResponse(VolleyError error) {
//                        progressDialog.hide();
                                Toast.makeText(v.getContext(), error.getMessage(), Toast.LENGTH_LONG).show();
                            }
                        }) {
                    @Override
                    protected Map<String, String> getParams() throws AuthFailureError {
                        Map<String, String> params = new HashMap<>();
                        params.put("event_id", event_id);
                        return params;
                    }
                };

                RequestHandler.getInstance(v.getContext()).addToRequestQueue(stringRequest);
            }
        });
    }

    @Override
    public int getItemCount() {
        return productList.size();
    }

    class ProductViewHolder extends RecyclerView.ViewHolder {

        TextView name, roomNo, building, event_id;
        Button auth;
        public ProductViewHolder(View itemView) {
            super(itemView);

            event_id = itemView.findViewById(R.id.eventId);
            name = itemView.findViewById(R.id.name);
            roomNo = itemView.findViewById(R.id.roomNo);
            building = itemView.findViewById(R.id.building);
            auth = (Button)itemView.findViewById((R.id.buttonAuth));

        }
    }
}