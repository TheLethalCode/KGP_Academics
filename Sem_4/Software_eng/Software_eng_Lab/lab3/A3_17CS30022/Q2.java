import java.applet.Applet;
import java.awt.Color;
import java.awt.Graphics;

public class Q2 extends Applet
{
    public void paint(Graphics g)
    {
        g.setColor(Color.blue);
        g.drawRect(40, 40, 200, 150);
        g.setColor(Color.red);
        g.drawString("Welcome", 50, 50);
    }
}