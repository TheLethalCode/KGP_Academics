import javax.swing.JFrame;
import javax.swing.JOptionPane;

public class SwingOptionPane
{
    JFrame f;
     
    SwingOptionPane()
    {
        f = new JFrame();
        JOptionPane.showMessageDialog(f, "Welcome");
    }

    public static void main(String[] args) {
        new SwingOptionPane();
    }
}