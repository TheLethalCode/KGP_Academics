package com.example.event_app;

public class Room {

    public int room_id;
    private String room_no;
    private int floor;
    private String building;

    public Room(int room_id, String room_no,int floor,String building) {
        this.room_id = room_id;
        this.room_no = room_no;
        this.floor = floor;
        this.building = building;
    }

    public  int get_room_id(){
        return room_id;
    }

    public  String  get_room_no(){
        return room_no;
    }

    public  int get_floor(){
        return floor;
    }

    public  String  get_building(){
        return building;
    }

}
