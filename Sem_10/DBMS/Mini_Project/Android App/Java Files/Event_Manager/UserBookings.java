package com.example.evm_android;

import androidx.appcompat.app.AppCompatActivity;

import android.os.StrictMode;
import android.view.View;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.ListView;
import android.widget.Toolbar;

import org.json.JSONArray;
import org.json.JSONObject;

import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListAdapter;
import android.widget.ListView;
import android.content.Intent;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.List;
import androidx.annotation.RequiresApi;

public class UserBookings extends AppCompatActivity {
    String urladdress = "http://localhost/users.php";
    String eventname;
    String username;
    BufferedInputStream is;
    String[] Users;
    String line = null;
    String result = null;
    @Override
    protected void onCreate(Bundle savedInstanceState) 
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_user_bookings);
        ListView listView = (ListView)findViewById(R.id.users);       
        retrievedata();
        ListAdapter myadapter = new ArrayAdapter<>(this,android.R.layout.simple_list_item_1,Users);
        listView.setAdapter(myadapter);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
         @Override
         public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
             if (position == 0 || position != 0)
             {
                 String fullName = "Shamik Sural";
                 Intent intent = new Intent(MainActivity.this, Main2Activity.class);
                 intent.putExtra(name:"full_name", fullName);
                 startActivity(intent);
             }
         }
     });
    }

    private void retrievedata()
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
        try{
            JSONArray ja = new JSONArray(result);
            JSONObject jo = null;
            Users = new String[ja.length()];
            String start;
            String mid="                         ";
            for(int i=0;i<ja.length();i++)
            {
                jo = ja.getJSONObject(i);
                String name,event_name;
                name = jo.getString("username");
                event_name = jo.getString("event_name");
                start="       ";
                start.concat(name);
                start.concat(mid);
                start.concat(event_name);
                Users[i]=start;
            }
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }

    }
}
