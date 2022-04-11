package com.example.event_app;

import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
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

public class viewRooms extends AppCompatActivity {

    private static final String URL_ROOMS = "http://192.168.0.4/event_app/viewRooms.php";

    List<Room> roomList;
    
    RecyclerView recyclerView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_view_rooms);

        Intent intent = getIntent();
        final Integer eId = intent.getIntExtra("em_id", 0);

        recyclerView = findViewById(R.id.recyclerView);
        recyclerView.setHasFixedSize(true);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        
        roomList = new ArrayList<>();
        
        loadRooms();
    }

    private void loadRooms() {


        StringRequest stringRequest = new StringRequest(Request.Method.GET, URL_ROOMS,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        try {
                            JSONObject jsonObject = new JSONObject(response);
                            String success = jsonObject.getString("success");
                            JSONArray jsonArray = jsonObject.getJSONArray("rooms");

                            if (success.equals("1")) {

                                for (int i = 0; i < jsonArray.length(); i++) {

                                    JSONObject object = jsonArray.getJSONObject(i);

                                    int room_id = object.getInt("room_id");
                                    String room_no = object.getString("room_no").trim();
                                    int floor = object.getInt("floor");
                                    String building = object.getString("building").trim();

                                    roomList.add(new Room(
                                            room_id, room_no, floor, building
                                    ));
                                }

                                RoomAdapter adapter = new RoomAdapter(viewRooms.this, roomList);
                                recyclerView.setAdapter(adapter);

                            }

                            else {
                                Toast.makeText(viewRooms.this, "No Rooms to show", Toast.LENGTH_SHORT).show();
                            }

                        } catch (JSONException e) {
                            e.printStackTrace();
                            Toast.makeText(viewRooms.this, "Error JSON : " + e.toString() + "\nUnable to fetch Rooms", Toast.LENGTH_SHORT).show();
                        }

                    }
                },
                new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {
                        Toast.makeText(viewRooms.this, "Error Volley : " + error.toString() + "\nUnable to fetch Rooms", Toast.LENGTH_SHORT).show();
                    }
                });


        RequestQueue requestQueue = Volley.newRequestQueue(this);
        requestQueue.add(stringRequest);

    }
}
