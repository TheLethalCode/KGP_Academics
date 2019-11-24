import java.applet.Applet;
import java.awt.Color;
import java.awt.Graphics;

public class Q3 extends Applet
{
    public void paint(Graphics g)
    {
        for(int i=0;i<8;i++)
        {
            for(int j=0;j<8;j++)
            {
                if((i+j)%2 == 0)
                    g.setColor(Color.red);
                else
                    g.setColor(Color.black);
                g.fillRect(i*20,j*20,20,20);
            }
        }
    }
}