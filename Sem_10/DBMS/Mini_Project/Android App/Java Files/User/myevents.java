package com.example.userapp;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Context;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.os.StrictMode;
import android.widget.ListView;
import android.widget.Toast;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

public class myevents extends AppCompatActivity {
    String urladd = "http://192.168.0.12/myevents.php";
    String name[];
    ListView listview;
    BufferedInputStream is;
    String line = null;
    String result = null;
    String username;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_myevents);
        listview = (ListView)findViewById(R.id.mlview);
        StrictMode.setThreadPolicy((new StrictMode.ThreadPolicy.Builder().permitNetwork().build()));
        SharedPreferences sharedPreferences = getSharedPreferences("MyData", Context.MODE_PRIVATE);
        this.username = sharedPreferences.getString("name","N/A");
        collectData();
        //Toast.makeText(this,name[0],Toast.LENGTH_LONG).show();
        EventListView  eventListView= new EventListView(this,name);
        //Toast.makeText(this,name[1],Toast.LENGTH_LONG).show();
        listview.setAdapter(eventListView);
    }
    private void collectData(){
        try
        {
            URL url = new URL(urladd);
            HttpURLConnection con = (HttpURLConnection)url.openConnection();
            con.setRequestMethod("POST");
            con.setDoOutput(true);
            con.setDoInput(true);
            OutputStream outputStream = con.getOutputStream();
            BufferedWriter bufferedWriter = new BufferedWriter(new OutputStreamWriter(outputStream,"UTF-8"));
            String post_data = URLEncoder.encode("username","UTF-8")+"="+URLEncoder.encode(username,"UTF-8");
            bufferedWriter.write(post_data);
            bufferedWriter.flush();
            bufferedWriter.close();
            outputStream.close();
            is = new BufferedInputStream(con.getInputStream());

        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
        try
        {
            BufferedReader br= new BufferedReader(new InputStreamReader(is));
            StringBuilder sb = new StringBuilder();
            while((line=br.readLine())!=null)
            {
                sb.append((line+"\n"));
            }
            is.close();
            result = sb.toString();
        }
        catch (Exception ex)
        {
            ex.printStackTrace();
        }
        try {
            JSONArray ja = new JSONArray(result);
            JSONObject jo = null;
            name = new String[ja.length()];
            for (int i=0;i<ja.length();i++)
            {
                jo = ja.getJSONObject(i);
                name[i] = jo.getString("Name");
            }
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }


    }
}
