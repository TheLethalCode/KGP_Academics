package com.example.event_app;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.recyclerview.widget.RecyclerView;

import java.util.List;

public class RoomAdapter extends RecyclerView.Adapter<RoomAdapter.RoomViewHolder> {

    private Context mCtx;
    private List<Room> roomList;

    public RoomAdapter(Context mCtx, List<Room> roomList) {
        this.mCtx = mCtx;
        this.roomList = roomList;
    }

    @Override
    public RoomViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        LayoutInflater inflater = LayoutInflater.from(mCtx);
        View view = inflater.inflate(R.layout.rooms_list, null);
        return new RoomViewHolder(view);
    }

    @Override
    public void onBindViewHolder(RoomViewHolder holder, final int position) {
        final Room room_test = roomList.get(position);

        //loading the image
//        Glide.with(mCtx)
//                .load(product.getImage())
//                .into(holder.imageView);
        holder.roomId.setText("Room Id : " + String.valueOf(room_test.get_room_id()));
        holder.roomNo.setText("Room No : " + room_test.get_room_no());
        holder.floor.setText("Floor No : " + String.valueOf(room_test.get_floor()));
        holder.building.setText("Building : " + room_test.get_building());
    }

    @Override
    public int getItemCount() {
        return roomList.size();
    }

    class RoomViewHolder extends RecyclerView.ViewHolder {

        TextView roomId, roomNo, floor, building;
        public RoomViewHolder(View itemView) {
            super(itemView);

            roomId = itemView.findViewById(R.id.eventId);
            roomNo = itemView.findViewById(R.id.eventName);
            floor = itemView.findViewById(R.id.eventDesc);
            building = itemView.findViewById(R.id.eventRoom);

        }
    }

}
