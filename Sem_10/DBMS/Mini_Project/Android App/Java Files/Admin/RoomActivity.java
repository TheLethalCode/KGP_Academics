package com.example.admin;

import androidx.appcompat.app.AppCompatActivity;

import android.app.ActionBar;
import android.os.Bundle;

import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;

import com.android.volley.AuthFailureError;
import com.android.volley.Request;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.google.android.material.floatingactionbutton.FloatingActionButton;
import com.google.android.material.snackbar.Snackbar;

import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;

import android.util.Log;
import android.view.View;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import org.json.JSONObject;
import org.json.JSONException;
import com.android.volley.Response;
//import org.eclipse.jetty.client.api;

import java.util.HashMap;
import java.util.Map;

public class RoomActivity extends AppCompatActivity implements View.OnClickListener{

    private EditText editTextRoom, editTextFloor, editTextBuilding, editTextCapacity;
    private Button buttonRegister;
    private ProgressDialog progressDialog;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_room);
        editTextRoom = (EditText) findViewById(R.id.editTextRoom);
        editTextFloor = (EditText) findViewById(R.id.editTextFloor);
        editTextBuilding = (EditText) findViewById(R.id.editTextBuilding);
        editTextCapacity = (EditText) findViewById(R.id.editTextCapacity);
        this.getSupportActionBar().setDisplayHomeAsUpEnabled(true);
//        textViewLogin = (TextView) findViewById(R.id.textViewLogin);
        buttonRegister = (Button) findViewById((R.id.buttonRegister));

        progressDialog = new ProgressDialog(this);

        buttonRegister.setOnClickListener(this);
//        textViewLogin.setOnClickListener(this);
    }

    private void createRoom() {
//        FullName`, `AdminEmail`, `UserName`, `Password`
        //editTextRoom, editTextFloor, editTextBuilding, editTextCapacity
        final String Room = editTextRoom.getText().toString().trim();
        final String Floor = editTextFloor.getText().toString().trim();
        final String Building = editTextBuilding.getText().toString().trim();
        final String Capacity = editTextCapacity.getText().toString().trim();
        progressDialog.setMessage("Registering room...");
        progressDialog.show();

        StringRequest stringRequest = new StringRequest(Request.Method.POST,
                Constants.URL_ROOM,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        progressDialog.dismiss();

                        try {
                            Log.i("json_obj","["+response+"]");
                            JSONObject jsonObject = new JSONObject(response);

                            Toast.makeText(getApplicationContext(), jsonObject.getString("message"), Toast.LENGTH_LONG).show();

                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                    }
                },
                new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {
                        progressDialog.hide();
                        Toast.makeText(getApplicationContext(), error.getMessage(), Toast.LENGTH_LONG).show();
                    }
                }) {
            @Override
            protected Map<String, String> getParams() throws AuthFailureError {
                Map<String, String> params = new HashMap<>();
                // `roomNo`, `floor`, `building`, `capacity`
                params.put("roomNo", Room);
                params.put("floor", Floor);
                params.put("building", Building);
                params.put("capacity", Capacity);
                return params;
            }
        };


        RequestHandler.getInstance(this).addToRequestQueue(stringRequest);


    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item){
        Intent myIntent = new Intent(getApplicationContext(), ProfileActivity.class);
        startActivityForResult(myIntent, 0);
        return true;
    }

    @Override
    public void onClick(View v) {
        if (v == buttonRegister)
            createRoom();
//        if(v == textViewLogin)
//            startActivity(new Intent(this, RoomActivity.class));
    }
}
