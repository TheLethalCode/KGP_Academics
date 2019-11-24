import java.applet.*;
import java.awt.*;

public class Q1 extends Applet
{
    public void paint(Graphics g)
    {
        setBackground(Color.green);
        g.setColor(Color.blue);
        g.drawString("Hello World", 20 ,20);
    }
}