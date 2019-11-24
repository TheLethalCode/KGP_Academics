public class Thread_R implements Runnable{
    Thread t;
    
    public Thread_R(String name) {
        t=new Thread(this, name);
        t.start();
    }

    @Override
    public void run(){
        for(int i=1;i<=10;i++){
            System.out.println(t.getName()+"::"+t.getPriority()+"::"+t.getState()+"::"+i);
            try {
                t.sleep(1000);
            } catch (InterruptedException ex) {
                System.out.println("A inturrpt has occured!");
            }
        }
    }
    public static void main(String[] args) {
        Thread_T th_t1=new Thread_T("T1");
        System.out.println(Thread.currentThread().getName()+"::"+Thread.currentThread().getState()+"::"+Thread.currentThread().getPriority());
        Thread_T th_t2=new Thread_T("T2");
        System.out.println(Thread.currentThread().getName()+"::"+Thread.currentThread().getState()+"::"+Thread.currentThread().getPriority());
        Thread_T th_t3=new Thread_T("T3");
        System.out.println(Thread.currentThread().getName()+"::"+Thread.currentThread().getState()+"::"+Thread.currentThread().getPriority());
	Thread_T th_t4=new Thread_T("T4");
        System.out.println(Thread.currentThread().getName()+"::"+Thread.currentThread().getState()+"::"+Thread.currentThread().getPriority());
    }
    
}
