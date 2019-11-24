import javax.swing.*;

public class Q5
{

    Q5()
    {
        JFrame f = new JFrame();

        String[][] data = {
            {"19XY10001","Sachin","90"},
            {"19XY10002","Laxman","85"},
            {"19XY10003","Rahul","95"}
        };
        String[] names = { "Roll No.", "Name", "Marks" };
        
        JTable tab = new JTable(data, names);
        tab.setBounds(30, 40, 200, 300);

        JScrollPane st = new JScrollPane(tab);
        f.add(st);
        f.setSize(500,300);
        // f.setLayout(null);
        f.setVisible(true); 
    }

    public static void main(String[] args) {
        new Q5();
    }
}