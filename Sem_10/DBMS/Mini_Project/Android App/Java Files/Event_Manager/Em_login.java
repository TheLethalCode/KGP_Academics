package com.example.event_app;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.os.TestLooperManager;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ProgressBar;
import android.widget.TextView;
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

import java.util.HashMap;
import java.util.Map;

public class Em_login extends AppCompatActivity {

    private EditText username, password;
    private Button btn_login;
    private TextView link_register;
    private ProgressBar loading;
    private static String URL_LOGIN = "http://192.168.0.4/event_app/login.php";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_em_login);

        loading = findViewById(R.id.progressBar);
        loading.setVisibility(View.GONE);
        username = findViewById(R.id.username);
        password = findViewById(R.id.password);
        btn_login = findViewById(R.id.btn_login);
        link_register = findViewById(R.id.register);

        btn_login.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String mUsername = username.getText().toString().trim();
                String mPassword = password.getText().toString().trim();

                if (mUsername.isEmpty()) {
                    username.setError("Please Insert Username");
                }
                else if (mPassword.isEmpty()) {
                    password.setError("Please Insert Password");
                }
                else {
                    Login(mUsername, mPassword);
                }
            }
        });

        link_register.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(new Intent(Em_login.this, MainActivity.class));
            }
        });

    }

    private void Login(final String username, final String password) {

        loading.setVisibility(View.VISIBLE);
        btn_login.setVisibility(View.GONE);

        StringRequest stringRequest = new StringRequest(Request.Method.POST, URL_LOGIN,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        try {
                            JSONObject jsonObject = new JSONObject(response);
                            String success = jsonObject.getString("success");
                            JSONArray jsonArray = jsonObject.getJSONArray("login");

                            if (success.equals("1")) {

                                for (int i = 0; i < jsonArray.length(); i++) {

                                    JSONObject object = jsonArray.getJSONObject(i);

                                    String name = object.getString("name").trim();
                                    String email = object.getString("email").trim();
                                    Integer em_id = object.getInt("em_id");

                                    // String id = object.getString("id").trim();
                                    String username = object.getString("username").trim();

                                    Toast.makeText(Em_login.this, "Success Login! \nName : "
                                            + name + "\nEmail : "
                                            + email + "\nId : "
                                            + em_id.toString(), Toast.LENGTH_SHORT).show();

                                    Intent intent = new Intent(Em_login.this, dashboard.class);
                                    intent.putExtra("name", name);
                                    intent.putExtra("email", email);
                                    intent.putExtra("em_id", em_id);
                                    startActivity(intent);

                                    loading.setVisibility(View.GONE);
                                    btn_login.setVisibility(View.VISIBLE);

                                }
                            }
                            else {
                                loading.setVisibility(View.GONE);
                                btn_login.setVisibility(View.VISIBLE);

                                Toast.makeText(Em_login.this, "Incorrect username or password\nTry Again !", Toast.LENGTH_SHORT).show();

                            }

                        } catch (JSONException e) {
                            e.printStackTrace();
                            loading.setVisibility(View.GONE);
                            btn_login.setVisibility(View.VISIBLE);
                            Toast.makeText(Em_login.this, "Error JSON " + e.toString(), Toast.LENGTH_SHORT).show();
                        }

                    }
                },
                new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {
                        loading.setVisibility(View.GONE);
                        btn_login.setVisibility(View.VISIBLE);
                        Toast.makeText(Em_login.this, "Error Volley " + error.toString(), Toast.LENGTH_SHORT).show();
                    }
                })
        {
            @Override
            protected Map<String, String> getParams() throws AuthFailureError {
                Map<String, String> params = new HashMap<>();
                params.put("username", username);
                params.put("password", password);
                return params;
            }
        };

        RequestQueue requestQueue = Volley.newRequestQueue(this);
        requestQueue.add(stringRequest);

    }
}
