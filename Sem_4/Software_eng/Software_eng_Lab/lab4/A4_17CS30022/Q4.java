import java.awt.Color;
import java.awt.Graphics;
import java.awt.Paint;
import java.util.Random;
import java.applet.*;

/*
<applet code="Q4" width="250" height="200">
</applet> */

public class Q4 extends Applet implements Runnable
{
    int x = 20;
    int col = 0;
    Random rand = new Random();
    Thread timer = null;
    Thread mover = null;

    @Override
    public void run() {
        if(Thread.currentThread().getName() == "color")
        {
            while(true)
            {
                try{
                    Thread.sleep(1250);
                }
                catch(InterruptedException e){
                }
                col++;
                repaint();
            }
        }
        else
        {
            while(true)
            {
                try{
                    Thread.sleep(80);
                }
                catch(InterruptedException e){
                }
                x++;
                repaint();
            }
        }
    }

    public void paint(Graphics g)
    {
        if(timer == null)
        {
            timer = new Thread(this,"color");
            mover = new Thread(this,"mover");
            timer.start();
            mover.start();
        }
        if(col % 2 ==0)
            g.setColor(Color.cyan);
        else
            g.setColor(Color.red);

        g.fillRect(x, 20, 67, 50);
        g.setColor(Color.black);
        g.drawString("Kousshik", x+5, 50);
    }
}