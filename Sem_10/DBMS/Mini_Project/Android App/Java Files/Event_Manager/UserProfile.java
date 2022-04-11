package com.example.evm_android;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.widget.ArrayAdapter;
import android.widget.ListAdapter;
import android.widget.ListView;

import androidx.annotation.RequiresApi;

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

public class UserProfile extends AppCompatActivity {
    String urladdress = "http://localhost/user_details.php";
    BufferedInputStream is;
    String[] Users = new String[3];
    String line = null;
    String result = null;
    String nm;
    @Override
    protected void onCreate(Bundle savedInstanceState) 
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_user_profile);
        ListView listView = (ListView)findViewById(R.id.details);
        Intent intent=getIntent();// : It gets the Intent from the LoginActivity.
        nm= intent.getStringExtra(“full_name”) 
        retrievedata();
        ListAdapter myadapter = new ArrayAdapter<>(this,android.R.layout.simple_list_item_1,Users);
        listView.setAdapter(myadapter);
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
            for(int i=0;i<ja.length();i++)
            {
                jo = ja.getJSONObject(i);
                String name,email,event_name;
                name = jo.getString("username");
                email = jo.getString("email");
                event_name = jo.getString("event_name");
                if(name==nm)
                {
                    String start="       ";
                    start.concat(name);
                    Users[0]=start;
                    start="       ";
                    start.concat(email);
                    Users[1]=start;
                    start="       ";
                    start.concat(event_name);
                    Users[2]=start;
                }
            }
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }

    }
}
