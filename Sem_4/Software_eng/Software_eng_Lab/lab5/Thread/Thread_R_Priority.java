public class Thread_R_Priority implements Runnable{
    Thread t;
    
    public Thread_R_Priority(String name, int P) {
        t=new Thread(this, name);
        t.setPriority(P);
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
        Thread_R_Priority th_t1=new Thread_R_Priority("T1",Thread.MAX_PRIORITY);
        System.out.println(Thread.currentThread().getName()+"::"+Thread.currentThread().getState()+"::"+Thread.currentThread().getPriority());
        Thread_R_Priority th_t2=new Thread_R_Priority("T2", Thread.MIN_PRIORITY);
        System.out.println(Thread.currentThread().getName()+"::"+Thread.currentThread().getState()+"::"+Thread.currentThread().getPriority());
        Thread_R_Priority th_t3=new Thread_R_Priority("T3", Thread.NORM_PRIORITY);
        System.out.println(Thread.currentThread().getName()+"::"+Thread.currentThread().getState()+"::"+Thread.currentThread().getPriority());
	Thread_R_Priority th_t4=new Thread_R_Priority("T4",6);
        System.out.println(Thread.currentThread().getName()+"::"+Thread.currentThread().getState()+"::"+Thread.currentThread().getPriority());
    }
    
}
