import java.awt.event.*;
import javax.swing.*;
import java.io.*;
import java.net.*;

// The client class responsible for sending a message
class UDPClient
{
    static String ip = new String("localhost");
    static int port = 9877;
    public static void ClientSend(String data) throws Exception
    {
        // Creates a socket on a free port to send message.
        DatagramSocket clientSocket = new DatagramSocket();
        InetAddress IPAddress = InetAddress.getByName(ip);
        
        byte[] sendData = new byte[10240];
        sendData = data.getBytes();
        
        System.out.println(IPAddress.getHostAddress());
        
        // Send the datagram packet
        DatagramPacket sendPacket = new DatagramPacket(sendData, sendData.length, IPAddress, port);
        clientSocket.send(sendPacket);
        
        // CLose the socket
        clientSocket.close();
    }
}

// The server class that runs in a separate thread
class UDPServer implements Runnable
{
    @Override
    public void run()
    {
        try
        {
            int port = 9876;
            DatagramSocket serverSocket = new DatagramSocket(port); // Create a datagram socket on the said port.
            System.out.println("Server Started: Host-" + InetAddress.getLocalHost() + " Port-" + port);
            byte[] receiveData = new byte[10240];

            // The server keeps listening to messages on the given port.
            while(true)
            {
                DatagramPacket receivePacket = new DatagramPacket(receiveData, receiveData.length);
                try
                {
                    serverSocket.receive(receivePacket);
                }
                catch(Exception e)
                {
                    System.out.println("Exception caught from server: "+e.toString());
                }

                String sentence = new String( receiveData,0,receivePacket.getLength());
                System.out.println("RECEIVED: " + sentence);

                // This updates the GUI with the received message
                chat.update(sentence);
            }
        }
        catch(Exception e)
        {
            System.out.println("Exception caught from server: "+e.toString());
        }
    }
}

// The main class where the GUI is loaded and the client datas are sent.
public class chat
{
    // Initialising various Jpanel elements.
    JFrame f;
    static JTextArea content;
    JScrollPane pane, sendpane;
    JTextArea area;
    JLabel l1,l2;
    JButton b1, b2;
    chat()
    {

        // Listening for message from friend.
        Thread server = new Thread(new UDPServer());
        server.start();

        // Setting up the GUI
        int size = 700;
        f = new JFrame("Mini Chatbox");

        area = new JTextArea();
        area.setLineWrap(true);
        area.setWrapStyleWord(true);
        sendpane = new JScrollPane(area);
        sendpane.setBounds(size/2 - 150,size - 130, 300,40);
        f.add(sendpane);

        b1= new JButton("Send");
        b1.setBounds(size/2 - 40, size - 80, 80, 30);
        f.add(b1);

        b2= new JButton("Clear History");
        b2.setBounds(size/2 - 70, size/2 + 80, 140, 30);
        f.add(b2);
        
        content = new JTextArea();
        content.setEditable(false);
        content.setLineWrap(true);
        content.setWrapStyleWord(true);
        pane = new JScrollPane(content);
        pane.setBounds(50, 50, size - 100, size/2);
        f.add(pane);
 
        l1 = new JLabel(" Message :- ");
        l1.setBounds(size/2 - 245, size - 125, 100, 30);
        f.add(l1);

        l2 = new JLabel(" Chat History ");
        l2.setBounds(size/2 - 65, 10, 130, 35);
        f.add(l2);

        // Dictates what happens when "send" is pressed. In this case, it sends to the listening IP.
        b1.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e){
                String data = area.getText();
                try {
                    UDPClient.ClientSend(data);
                    area.setText("");
                    content.append("\nYOU :- " + data.trim() + "\n");
                } catch (Exception k) {
                    System.out.println("Exception caught while sending: "+k.toString());
                }
            }
        });

        // Dictates what happens when "clear history" is pressed. In this case, clears the history.
        b2.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e){
                content.setText("");
            }
        });
        
        f.setSize(size, size);
        f.setLayout(null);
        f.setVisible(true);
    }

    // Function, to update the GUI when friend sends a message.
    public static void update(String co)
    {
        content.append("\nFRIEND:- "+co.trim()+"\n");
    }

    // The main program. Creates the Chat class.
    public static void main(String[] args) {
        new chat();    
    }
}