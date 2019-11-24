class Print implements Runnable
{
    @Override
    public void run() {
        System.out.println("Started thread " + Thread.currentThread().getName());
        details();
        for(int i=1;i<=10;i++)
        {
            System.out.println("From " + Thread.currentThread().getName() + " - " + i);
            try
            {
                Thread.sleep(1000);
            }
            catch(InterruptedException e)
            {
            }
        }
        System.out.println("Ended thread " + Thread.currentThread().getName());
    }
    void details()
    {
        System.out.println("Name :- " + Thread.currentThread().getName());
        System.out.println(Thread.currentThread().getName() + " State :- " + Thread.currentThread().getState());
        System.out.println(Thread.currentThread().getName() + " Priority :- " + Thread.currentThread().getPriority());
    }
}

public class Q2
{
    public static void main(String[] args) {
        Thread t1 = new Thread(new Print(),"T1");
        Thread t2 = new Thread(new Print(),"T2");
        Thread t3 = new Thread(new Print(),"T3");
        Thread t4 = new Thread(new Print(),"T4");
        t1.setPriority(Thread.MAX_PRIORITY);
        t2.setPriority(Thread.MIN_PRIORITY);
        t3.setPriority(Thread.NORM_PRIORITY);
        t4.setPriority(8);
        t1.start();
        t2.start();
        t3.start();
        t4.start();
        
    }
}