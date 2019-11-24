import javax.swing.*;

public class SwingRadioButton
{
    JFrame f;

    SwingRadioButton()
    {
        f = new JFrame();
        JLabel l1=new JLabel("Select your meal preference:");
        JRadioButton r1 = new JRadioButton("A) Veg");
        JRadioButton r2 = new JRadioButton("A) Non-Veg");
        JButton b= new JButton("Submit");
        l1.setBounds(75,30,200,30);
        r1.setBounds(75,80,100,30);
        r2.setBounds(75,100,100,30);
        b.setBounds(75, 150, 100, 30);
        ButtonGroup bg = new ButtonGroup();
        bg.add(r1);
        bg.add(r2);
        f.add(l1);
        f.add(r1);
        f.add(r2);
        f.add(b);
        f.setSize(400,400);
        f.setLayout(null);
        f.setVisible(true);
    }

    public static void main(String[] args) {
        new SwingRadioButton();
    }
}