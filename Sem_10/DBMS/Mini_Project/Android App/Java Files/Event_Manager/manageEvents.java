package com.example.event_app;

import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.content.Intent;
import android.os.Bundle;
import android.widget.Toast;

import com.android.volley.AuthFailureError;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class manageEvents extends AppCompatActivity {

    private static final String URL_EVENTS = "http://192.168.0.4/event_app/viewEvents.php";

    List<Event> eventList;

    RecyclerView recyclerView;

    private Integer em_id;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_manage_events);

        Intent intent = getIntent();
        em_id = intent.getIntExtra("eID", 0);

        recyclerView = findViewById(R.id.recyclerView);
        recyclerView.setHasFixedSize(true);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));

        eventList = new ArrayList<>();

        loadEvents();
    }

    private void loadEvents() {


        StringRequest stringRequest = new StringRequest(Request.Method.POST, URL_EVENTS,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        try {
                            JSONObject jsonObject = new JSONObject(response);
                            String success = jsonObject.getString("success");
                            JSONArray jsonArray = jsonObject.getJSONArray("events");

                            if (success.equals("1")) {

                                for (int i = 0; i < jsonArray.length(); i++) {

                                    JSONObject object = jsonArray.getJSONObject(i);

                                    int event_id = object.getInt("event_id");
                                    int event_status = object.getInt("event_status");
                                    String event_name = object.getString("event_name").trim();
                                    String event_desc = object.getString("event_desc").trim();
                                    String event_room = object.getString("event_room").trim();
                                    String event_date = object.getString("event_date").trim();
                                    String event_time = object.getString("event_time").trim();

                                    eventList.add(new Event(
                                            event_id, event_status, event_name, event_desc, event_room, event_date, event_time
                                    ));
                                }

                                EventAdapter adapter = new EventAdapter(manageEvents.this, eventList);
                                recyclerView.setAdapter(adapter);

                            }

                            else {
                                Toast.makeText(manageEvents.this, "No Events to Show", Toast.LENGTH_SHORT).show();
                            }

                        } catch (JSONException e) {
                            e.printStackTrace();
                            Toast.makeText(manageEvents.this, "Error JSON : " + e.toString() + "\nUnable to fetch Events", Toast.LENGTH_SHORT).show();
                        }

                    }
                },
                new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {
                        Toast.makeText(manageEvents.this, "Error Volley : " + error.toString() + "\nUnable to fetch Events", Toast.LENGTH_SHORT).show();
                    }
                })
        {
            @Override
            protected Map<String, String> getParams() throws AuthFailureError {
                Map<String, String> params = new HashMap<>();
                params.put("em_id", em_id.toString());
                return params;
            }
        };


        RequestQueue requestQueue = Volley.newRequestQueue(this);
        requestQueue.add(stringRequest);

    }

}
