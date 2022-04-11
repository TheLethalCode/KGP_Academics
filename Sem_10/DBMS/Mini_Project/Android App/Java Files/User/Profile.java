package com.example.userapp;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Context;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

public class Profile extends AppCompatActivity {
    TextView usernametv;
    public static final String Default = "N/A";
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_profile);
        usernametv = (TextView) findViewById(R.id.usernameEt);
        SharedPreferences sharedPreferences = getSharedPreferences("MyData", Context.MODE_PRIVATE);
        String name = sharedPreferences.getString("name",Default);
        if(name.equals(Default))
        {
            Toast.makeText(this,"No Data Found",Toast.LENGTH_LONG).show();
        }
        else
        {
            usernametv.setText(name);
        }

    }
}
