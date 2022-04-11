package com.example.userapp;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

public class CustomListView extends ArrayAdapter<String> {
    private String [] eventname,eventdesc,eventdates;
    private Activity context;
    private String username;
    public static final String Default = "N/A";
    public CustomListView(Activity context,String[] eventname,String[] eventdates,String[] eventdesc,String username)
    {
        super(context,R.layout.layout,eventname);
        this.context = context;
        this.eventname = eventname;
        this.eventdesc = eventdesc;
        this.eventdates = eventdates;
        this.username = username;

    }
    @NonNull
    @Override
    public View getView(int position, @Nullable View convertView, @NonNull ViewGroup parent)
    {
        View r = convertView;

        ViewHolder viewHolder = null;
        if(r==null)
        {
            LayoutInflater layoutInflater = context.getLayoutInflater();
            r = layoutInflater.inflate(R.layout.layout,null,true);
            viewHolder = new ViewHolder(r);
            r.setTag(viewHolder);
        }
        else
        {
            viewHolder =(ViewHolder)r.getTag();

        }

        viewHolder.tvw1.setText(eventname[position]);
        viewHolder.tvw2.setText(eventdates[position]);
        viewHolder.tvw3.setText(eventdesc[position]);
        return r;
    }
     class ViewHolder{
        TextView tvw1;
        TextView tvw2;
        TextView tvw3;
        Button Regbtn;
        ViewHolder(View v)
        {
            tvw1 = (TextView) v.findViewById(R.id.eventName);
            tvw2 = (TextView) v.findViewById(R.id.eventDate);
            tvw3 = (TextView) v.findViewById(R.id.eventDes);
            Regbtn = (Button) v.findViewById(R.id.btnsignup);
            Regbtn.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v)
                {
                    Toast.makeText(context,"You are successfully registered for the event ",Toast.LENGTH_LONG).show();
                    BackgroundWorker backgroundWorker = new BackgroundWorker(context);

                    String type = "part";
                    String eventname = tvw1.getText().toString();
                    backgroundWorker.execute(type, username, eventname);
                }
            });
        }

    }




}

