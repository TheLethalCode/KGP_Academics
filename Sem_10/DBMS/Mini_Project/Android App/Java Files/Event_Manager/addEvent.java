package com.example.event_app;

import androidx.appcompat.app.AppCompatActivity;

import android.app.DatePickerDialog;
import android.app.TimePickerDialog;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.TimePicker;
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
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class addEvent extends AppCompatActivity {

    private Button btn_back;
    private Button btn_getRooms;
    private Button btn_addEvent;

    private TextView event_date;
    private DatePickerDialog.OnDateSetListener mDateSetListener;

    private TextView event_time;
    private TimePickerDialog.OnTimeSetListener mTimeSetListener;

    private Spinner mySpinner;
    private ArrayList<String> listItems = new ArrayList<>();
    private ArrayAdapter<String> adapter;

    private EditText name, desc;
    private Integer em_id;

    private static String URL_ROOMS = "http://192.168.0.4/event_app/get_rooms.php";
    private static String URL_ADD_EVENT = "http://192.168.0.4/event_app/add_event.php";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_add_event);

        Intent intent_em = getIntent();
        em_id = intent_em.getIntExtra("eID", 0);;

        name = findViewById(R.id.eName);
        desc = findViewById(R.id.eDescription);

        event_time  = (TextView) findViewById(R.id.eTime);


        btn_back = findViewById(R.id.back);
        btn_getRooms = findViewById(R.id.getRooms);
        btn_addEvent = findViewById(R.id.cEvent);

        mySpinner = (Spinner) findViewById(R.id.rooms_spinner);
        adapter = new ArrayAdapter<String>(this, R.layout.spinner_layout, R.id.txt, listItems);
        mySpinner.setAdapter(adapter);
        listItems.add("None");
        adapter.notifyDataSetChanged();


        event_date = (TextView) findViewById(R.id.eDate);

        btn_addEvent.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                int flag = 0;
                flag = add_event();

                if (flag == 0) {
                    Toast.makeText(addEvent.this, "Error : Enter Complete Details", Toast.LENGTH_SHORT).show();
                }
                else {
//                    Toast.makeText(addEvent.this, "Event Creation Successful", Toast.LENGTH_SHORT).show();
                    finish();
                }
            }
        });



        btn_getRooms.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String eDate = event_date.getText().toString().trim();

                listItems.clear();

                if (eDate.isEmpty()) {
                    get_rooms("None");
                }
                else {
                    get_rooms(eDate);
                }
            }
        });




        event_date.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Calendar cal = Calendar.getInstance();
                int year = cal.get(Calendar.YEAR);
                int month = cal.get(Calendar.MONTH);
                int day = cal.get(Calendar.DAY_OF_MONTH);
                int date = cal.get(Calendar.DATE);

                DatePickerDialog dialog = new DatePickerDialog(
                        addEvent.this,
                        android.R.style.Theme_Holo_Light_Dialog_MinWidth,
                        mDateSetListener,
                        year, month, day);

                dialog.getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
                dialog.show();

            }
        });

        mDateSetListener = new DatePickerDialog.OnDateSetListener() {
            @Override
            public void onDateSet(DatePicker view, int year, int month, int dayOfMonth) {
                month = month + 1;
                String date = dayOfMonth + "/" + month + "/" + year;
                event_date.setText(date);
            }
        };

        event_time.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Calendar cal = Calendar.getInstance();
                int hour = cal.get(Calendar.HOUR_OF_DAY);
                int minute = cal.get(Calendar.MINUTE);

                TimePickerDialog dialog = new TimePickerDialog(addEvent.this, mTimeSetListener, hour, minute, true);

                dialog.getWindow().setBackgroundDrawable(new ColorDrawable(Color.WHITE));
                dialog.show();
            }
        });

        mTimeSetListener = new TimePickerDialog.OnTimeSetListener() {
            @Override
            public void onTimeSet(TimePicker view, int hourOfDay, int minute) {
                String time = hourOfDay + ":" + minute;
                event_time.setText(time);
            }
        };

        btn_back.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
    }



    private int add_event() {

        final String name = this.name.getText().toString().trim();
        final String desc = this.desc.getText().toString().trim();
        final String date = this.event_date.getText().toString().trim();
        final String time = this.event_time.getText().toString().trim();
        final String room = this.mySpinner.getSelectedItem().toString().trim();
        final Integer eID = (Integer) this.em_id;


        final String test = "test";

        if (name.isEmpty() || desc.isEmpty() || date.isEmpty() || time.isEmpty() || room.isEmpty() || room.equalsIgnoreCase("None")) {
            return 0;
        }

        StringRequest stringRequest = new StringRequest(Request.Method.POST, URL_ADD_EVENT,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        try {
                            JSONObject jsonObject;
                            jsonObject = new JSONObject(response);
                            String test = "";
                            String success = jsonObject.getString("success");

                            if (success.equals("1")) {
                                Toast.makeText(addEvent.this, "Event creation successful", Toast.LENGTH_SHORT).show();
                            }

                        } catch (JSONException e) {
                            e.printStackTrace();
                            Toast.makeText(addEvent.this, "JSON Error : " + e.toString() +  "\nEvent Couldn't be created. Please try again", Toast.LENGTH_SHORT).show();

                        }
                    }
                },
                new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {
                        Toast.makeText(addEvent.this, "VolleyError : " + error.toString() + "\nEvent Couldn't be created. Please try again", Toast.LENGTH_SHORT).show();
                    }
                }) {
            @Override
            protected Map<String, String> getParams() throws AuthFailureError {
                Map<String, String> params = new HashMap<>();
                params.put("event_name", name);
                params.put("event_desc", desc);
                params.put("event_date", date);
                params.put("event_time", time);
                params.put("event_room", room);
                params.put("em_id", eID.toString());
                return params;
            }
        };

        RequestQueue requestQueue = Volley.newRequestQueue(this);
        requestQueue.add(stringRequest);
        return 1;
    }


    private void get_rooms(final String eDate) {

        StringRequest stringRequest = new StringRequest(Request.Method.POST, URL_ROOMS,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        try {
                            JSONObject jsonObject = new JSONObject(response);
                            String success = jsonObject.getString("success");
                            JSONArray jsonArray = jsonObject.getJSONArray("rooms");

                            ArrayList<String> list_new;
                            list_new = new ArrayList<>();

                            if (success.equals("1")) {

                                for (int i = 0; i < jsonArray.length(); i++) {

                                    JSONObject object = jsonArray.getJSONObject(i);

                                    String roomNo = object.getString("room_no").trim();
                                    Integer room_id = object.getInt("room_id");

                                    list_new.add(roomNo);
                                }

                                listItems.addAll(list_new);
                                adapter.notifyDataSetChanged();

                            }

                            else {
                                list_new.add("None");
                                listItems.addAll(list_new);
                                adapter.notifyDataSetChanged();
                            }

                        } catch (JSONException e) {
                            e.printStackTrace();
                            Toast.makeText(addEvent.this, "Error JSON " + e.toString(), Toast.LENGTH_SHORT).show();
                        }

                    }
                },
                new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {
                        Toast.makeText(addEvent.this, "Error Volley " + error.toString(), Toast.LENGTH_SHORT).show();
                    }
                })
        {
            @Override
            protected Map<String, String> getParams() throws AuthFailureError {
                Map<String, String> params = new HashMap<>();
                params.put("eDate", eDate);
                return params;
            }
        };

        RequestQueue requestQueue = Volley.newRequestQueue(this);
        requestQueue.add(stringRequest);

    }

}
