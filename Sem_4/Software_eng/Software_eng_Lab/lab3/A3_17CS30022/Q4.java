import javax.swing.*;

public class Q4
{
    JFrame f;

    Q4()
    {
        f = new JFrame();
        JLabel l1=new JLabel("Username: ");
        JLabel l2=new JLabel("Password: ");
        JTextArea area = new JTextArea();
        JPasswordField pass = new JPasswordField();
        JButton b1= new JButton("Login");
        JButton b2= new JButton("Clear");
        l1.setBounds(75,30,100,30);
        l2.setBounds(75,80,100,30);
        area.setBounds(165,30,100,30);
        pass.setBounds(165,80,100,30);
        b1.setBounds(105, 150, 100, 30);
        b2.setBounds(220, 150, 100, 30);
        f.add(l1);
        f.add(l2);
        f.add(b1);
        f.add(b2);
        f.add(area);
        f.add(pass);
        f.setSize(400, 400);
        f.setLayout(null);
        f.setVisible(true);
    }

    public static void main(String[] args) {
        new Q4();
    }
}