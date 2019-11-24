import java.awt.Color;
import java.awt.Graphics;
import java.awt.Paint;
import java.applet.*;

/*
<applet code="Q3" width="250" height="200">
</applet> */

public class Q3 extends Applet implements Runnable
{
    int cnt = 0;
    Thread timer = null;
    @Override
    public void run() {
        while(true)
        {
            try{
                Thread.sleep(1000);
            }
            catch(InterruptedException e){
            }
            cnt++;
            repaint();
        }
    }

    public void paint(Graphics g)
    {
        if(timer == null)
        {
            timer = new Thread(this);
            timer.start();
        }
        if(cnt%2 == 0 )
            g.setColor(Color.red);
        else
            g.setColor(Color.green);
        g.drawString("HELLO WORLD", 50, 50);
    }
}