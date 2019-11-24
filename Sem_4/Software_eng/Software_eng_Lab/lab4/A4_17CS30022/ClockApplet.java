import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;
import java.sql.Date;
import java.applet.*;

/*
<applet code="ClockApplet" width="250" height="200">
</applet> */

public class ClockApplet extends Applet implements Runnable
{
    Font theFont = new Font("TimesRoman",Font.BOLD,24);
    Date theDate;
    Thread runner;

    public void start()
    {
        if(runner == null)
        {
            runner = new Thread(this);
            runner.start();
        }
    }

    public void stop()
    {
        if( runner != null)
        {
            runner.stop();
            runner = null;
        }
    }

    @Override
    public void run() {
        while(true)
        {
            theDate = new Date(19, 2, 13);
            repaint();
            try
            {
                Thread.sleep(1000);
            }
            catch ( InterruptedException e)
            {

            }
        }
    }

    public void paint(Graphics g)
    {
        setBackground(Color.red);
        g.setFont(theFont);
        g.drawString(theDate.toString(), 10, 50);
    }
}