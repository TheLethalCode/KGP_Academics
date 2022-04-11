package com.example.userapp;

import android.app.Activity;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;


public class EventListView extends ArrayAdapter<String> {
    private String[] name;
    private Activity context;
    public EventListView(Activity context, String[] name) {
        super(context, R.layout.layout2,name);
        this.context = context;
        this.name = name;
    }
    @NonNull
    @Override
    public View getView(int position, @Nullable View convertView,@NonNull ViewGroup parent)
    {
        View r = convertView;

        ViewHolder viewHolder = null;
        if(r==null)
        {
            LayoutInflater layoutInflater = context.getLayoutInflater();
            r = layoutInflater.inflate(R.layout.layout2,null,true);
            viewHolder = new ViewHolder(r);
            r.setTag(viewHolder);
        }
        else
        {
            viewHolder =(ViewHolder)r.getTag();

        }
        viewHolder.tvw1.setText(name[position]);
        return r;
    }
    class ViewHolder{
        TextView tvw1;
        ViewHolder(View v)
        {
            tvw1 = (TextView) v.findViewById(R.id.myeve);

        }
    }
}
