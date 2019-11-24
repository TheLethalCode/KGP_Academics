import java.applet.*;
import java.awt.*;

/*
 <applet code="Face" width=200 height=60></applet>
*/

public class Face extends Applet
{
    public void paint(Graphics g)
    {
        g.drawOval(40, 40, 120, 150);
        g.drawOval(57, 75, 20, 30);
        g.drawOval(110, 75, 20, 30);
        g.fillOval(68, 81, 10, 10);
        g.fillOval(121, 81, 10, 10);
        g.drawOval(85,100,30,30);
        g.fillArc(60, 125, 80, 40, 180, 180);
        g.drawOval(25, 92, 15, 30);
        g.drawOval(160, 92, 15, 30);
    }
}

