package com.example.event_app;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import androidx.recyclerview.widget.RecyclerView;

import com.android.volley.AuthFailureError;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class EventAdapter extends RecyclerView.Adapter<EventAdapter.EventViewHolder> {

    private Context mCtx;
    private List<Event> eventList;

    public EventAdapter(Context mCtx, List<Event> eventList) {
        this.mCtx = mCtx;
        this.eventList = eventList;
    }

    @Override
    public EventViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        LayoutInflater inflater = LayoutInflater.from(mCtx);
        View view = inflater.inflate(R.layout.event_booking, null);
        return new EventViewHolder(view);
    }

    @Override
    public void onBindViewHolder(final EventViewHolder holder, final int position) {
        final Event event_test = eventList.get(position);

        holder.event_id.setText("Event Id : " + String.valueOf(event_test.get_event_id()));
        holder.event_name.setText("Event Name : " + event_test.get_event_name());
        holder.event_desc.setText("Description : " + event_test.get_event_desc());
        holder.event_room.setText("Venue : " + event_test.get_event_room());
        holder.event_date.setText("Date : " + event_test.get_event_date());
        holder.event_time.setText("Time : " + event_test.get_event_time());

        if (event_test.get_event_status() == 0) {
            holder.event_status.setText("Status = Inactive");
        }
        else {
            holder.event_status.setText("Status = Active");
        }

        holder.btn_delete.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(final View v) {

                final String  event_id = String.valueOf(eventList.get(position).get_event_id());


                StringRequest stringRequest = new StringRequest(Request.Method.POST, Event.URL_DELETE_EVENT,
                        new Response.Listener<String>() {
                            @Override
                            public void onResponse(String response) {
                                try {
                                    JSONObject jsonObject;
                                    jsonObject = new JSONObject(response);
                                    String success = jsonObject.getString("success");

                                    if (success.equals("1")) {
                                        Toast.makeText(v.getContext(), "Deletion Success", Toast.LENGTH_SHORT).show();
                                        holder.btn_delete.setEnabled(false);
                                        holder.btn_delete.setText("Deleted !");
                                    }

                                } catch (JSONException e) {
                                    e.printStackTrace();
                                    Toast.makeText(v.getContext(), "JSON Deletion Error : " + e.toString(), Toast.LENGTH_SHORT).show();

                                }
                            }
                        },
                        new Response.ErrorListener() {
                            @Override
                            public void onErrorResponse(VolleyError error) {
                                Toast.makeText(v.getContext(), "Volley Deletion Error : " + error.toString(), Toast.LENGTH_SHORT).show();
                            }
                        }) {
                    @Override
                    protected Map<String, String> getParams() throws AuthFailureError {
                        Map<String, String> params = new HashMap<>();
                        params.put("event_id", event_id);
                        return params;
                    }
                };

                RequestQueue requestQueue = Volley.newRequestQueue(v.getContext());
                requestQueue.add(stringRequest);


            }
        });

    }

    @Override
    public int getItemCount() {
        return eventList.size();
    }

    class EventViewHolder extends RecyclerView.ViewHolder {

        TextView event_id, event_status, event_name, event_desc, event_room, event_date, event_time;
        Button btn_delete;

        public EventViewHolder(View itemView) {
            super(itemView);

            event_id = itemView.findViewById(R.id.eventId);
            event_status = itemView.findViewById(R.id.eventStatus);
            event_name = itemView.findViewById(R.id.eventName);
            event_desc = itemView.findViewById(R.id.eventDesc);
            event_room = itemView.findViewById(R.id.eventRoom);
            event_date = itemView.findViewById(R.id.eventDate);
            event_time = itemView.findViewById(R.id.eventTime);
            btn_delete = itemView.findViewById(R.id.eventDelete);

        }
    }

}
