package com.example.userapp;

import androidx.annotation.RequiresApi;
import androidx.appcompat.app.AppCompatActivity;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Build;
import android.os.Bundle;
import android.os.StrictMode;
import android.view.View;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.ListView;
import android.widget.Toolbar;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.List;

public class Events extends AppCompatActivity {
    String urladdress = "http://192.168.0.12/events.php";
    String[] eventname,eventdates,eventdesc;
    String username;
    ListView listView;
    BufferedInputStream is;
    String line = null;
    String result = null;
    private ImageButton button;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_events);
        listView =(ListView)findViewById(R.id.lview);
        button = findViewById(R.id.mebtn);
        button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                openProfile();
            }
        }) ;
        StrictMode.setThreadPolicy((new StrictMode.ThreadPolicy.Builder().permitNetwork().build()));
        CollectData();
        SharedPreferences sharedPreferences = getSharedPreferences("MyData", Context.MODE_PRIVATE);
        username = sharedPreferences.getString("name","N/A");

        CustomListView customListView = new CustomListView(this,eventname,eventdates,eventdesc,username);
        listView.setAdapter(customListView);

    }

    private void CollectData()
    {
        try {
            URL url = new URL(urladdress);
            HttpURLConnection con = (HttpURLConnection)url.openConnection();
            con.setRequestMethod("GET");
            is = new BufferedInputStream(con.getInputStream());
        }
        catch (Exception e){
            e.printStackTrace();
        }
 //content
        try{
            BufferedReader br = new BufferedReader(new InputStreamReader(is));
            StringBuilder sb = new StringBuilder();
            while((line=br.readLine())!=null){
                sb.append(line+'\n');
            }
            is.close();
            result = sb.toString();

        }
        catch (Exception ex)
        {
            ex.printStackTrace();
        }
   //JSON
        try{
            JSONArray ja = new JSONArray(result);
            JSONObject jo = null;
            eventname = new String[ja.length()];
            eventdates = new String[ja.length()];
            eventdesc = new String[ja.length()];
            for(int i=0;i<ja.length();i++)
            {
                jo = ja.getJSONObject(i);
                eventname[i] = jo.getString("Name");
                eventdesc[i] = jo.getString("Description");
                eventdates[i] = jo.getString("Startdate")+" at "+jo.getString("Time");
            }
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }

    }
    public void openProfile()
    {
        Intent intent = new Intent(this,myevents.class);
        startActivity(intent);
    }
}
