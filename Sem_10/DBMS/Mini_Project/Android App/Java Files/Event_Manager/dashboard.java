package com.example.event_app;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

public class dashboard extends AppCompatActivity {

    private TextView name, email, vId;
    private Button btn_logout;
    private Button btn_aEvent, btn_mEvents, btn_vRooms;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_dashboard);

        name = findViewById(R.id.eventId);
        email = findViewById(R.id.email);
        vId = findViewById(R.id.view_id);
        btn_logout = findViewById(R.id.logout);

        btn_aEvent = findViewById(R.id.aEvent);
        btn_mEvents = findViewById(R.id.mEvent);
        btn_vRooms = findViewById(R.id.vRooms);

        Intent intent = getIntent();
        String eName = intent.getStringExtra("name");
        String eEmail = intent.getStringExtra("email");
        final Integer eId = intent.getIntExtra("em_id", 0);

        name.setText(eName);
        email.setText(eEmail);
        vId.setText("User Id : " + eId.toString());

        btn_aEvent.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(dashboard.this, addEvent.class);
                intent.putExtra("eID", eId);
                startActivity(intent);
            }
        });

        btn_mEvents.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(dashboard.this, manageEvents.class);
                intent.putExtra("eID", eId);
                startActivity(intent);
            }
        });

        btn_vRooms.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(dashboard.this, viewRooms.class);
                intent.putExtra("eID", eId);
                startActivity(intent);
            }
        });

        btn_logout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });

    }
}
