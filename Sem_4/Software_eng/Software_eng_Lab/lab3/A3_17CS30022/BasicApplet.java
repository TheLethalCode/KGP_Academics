import java.applet.*;
import java.awt.*;

public class BasicApplet extends Applet
{
    public void paint(Graphics g)
    {
        g.drawRect(50, 80, 200, 150);
        g.fillRect(50, 380, 200, 150);
        g.drawOval(350, 80, 200, 150);
        g.fillOval(350, 380, 200, 150);
        g.setColor(Color.red);
        g.drawString("Hello", 20 ,20);
    }
}

