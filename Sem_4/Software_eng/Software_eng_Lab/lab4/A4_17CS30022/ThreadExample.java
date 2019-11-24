class RunnableThread implements Runnable
{
    @Override
    public void run() {
        System.out.println("Runnable Thread - Start " + Thread.currentThread().getName());
        try
        {
            Thread.sleep(1000);
            doprocessing();
        }
        catch ( InterruptedException e)
        {
            e.printStackTrace();
        }
        System.out.println("Runnable Thread - End "  + Thread.currentThread().getName());
    }

    private void doprocessing() throws InterruptedException
    {
        Thread.sleep(5000);
    } 
}

class Mythread extends Thread
{
    public Mythread(String name)
    {
        super(name);
    }

    @Override
    public void run() {
        System.out.println("MyThread START " + Thread.currentThread().getName());
        try
        {
            Thread.sleep(1000);
            doprocessing();
        }
        catch ( InterruptedException e)
        {
            e.printStackTrace();
        }
        System.out.println("MyThread Thread - End "  + Thread.currentThread().getName());
    }

    private void doprocessing() throws InterruptedException
    {
        Thread.sleep(5000);
    } 
}

public class ThreadExample
{
    public static void main(String[] args) {
        Thread t1 = new Thread( new RunnableThread(),"t1");
        Thread t2 = new Thread( new RunnableThread(),"t2");
        Thread t3 = new Thread( new RunnableThread(),"t3");
        Thread t4 = new Thread( new RunnableThread(),"t4");
        Thread t5 = new Thread( new RunnableThread(),"t5");
        System.out.println("Starting Runnable Threads");
        t1.start();
        t2.start();
        t3.start();
        t4.start();
        t5.start();
        System.out.println("Runnable Threads Started");
        Thread t6 = new Thread( new Mythread("t6"));
        Thread t7 = new Thread( new Mythread("t7"));
        Thread t8 = new Thread( new Mythread("t8"));
        Thread t9 = new Thread( new Mythread("t9"));
        Thread t10 = new Thread( new Mythread("t10"));
        System.out.println("Starting My Threads");
        t6.start();
        t7.start();
        t8.start();
        t9.start();
        t10.start();
        System.out.println("My Threads Started");
    }
}