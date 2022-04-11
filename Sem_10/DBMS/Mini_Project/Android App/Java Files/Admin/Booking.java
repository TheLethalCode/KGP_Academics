package com.example.admin;
public class Booking {
    public int event_id;
    private String name;
    private String roomNo;
    private String building;

    public Booking(int event_id, String name,String roomNo,String building) {
        this.event_id = event_id;
        this.name = name;
        this.roomNo = roomNo;
        this.building = building;
    }

    public  int getevent_id(){
        return event_id;
    }

    public String getname() {
        return name;
    }

    public String getroomNo() {
        return roomNo;
    }

    public String getbuilding() {
        return building;
    }

}
