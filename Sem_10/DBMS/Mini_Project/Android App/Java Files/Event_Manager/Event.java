package com.example.event_app;

public class Event {

    public int event_id;
    private int event_status;
    private String event_name;
    private String event_desc;
    private String event_room;
    private String event_date;
    private String event_time;

    public static final String URL_DELETE_EVENT = "http://192.168.0.4/event_app/deleteEvent.php";

    public Event(int event_id, int event_status, String event_name, String event_desc, String event_room, String event_date, String event_time) {
        this.event_id = event_id;
        this.event_status = event_status;
        this.event_name = event_name;
        this.event_desc = event_desc;
        this.event_room = event_room;
        this.event_date = event_date;
        this.event_time = event_time;
    }

    public  int get_event_id(){
        return event_id;
    }

    public  int get_event_status(){
        return event_status;
    }

    public  String  get_event_name(){
        return event_name;
    }

    public  String get_event_desc(){
        return event_desc;
    }

    public  String  get_event_room(){
        return event_room;
    }

    public  String  get_event_date(){
        return event_date;
    }

    public  String  get_event_time(){
        return event_time;
    }

}
