public class Thread_T_Priority extends Thread{

    public Thread_T_Priority(String name, int P) {
        super.setName(name);
        super.setPriority(P);
        this.start();
    }

    @Override
    public void run(){
        for(int i=1;i<=10;i++){
            System.out.println(this.getName()+"::"+this.getPriority()+"::"+this.getState()+"::"+i);
            try {
                this.sleep(1000);
            } catch (InterruptedException ex) {
                System.out.println("A inturrpt has occured!");
            }
        }
    }
    public static void main(String[] args) {
        Thread_T_Priority th_t1=new Thread_T_Priority("T1",Thread.MAX_PRIORITY);
        System.out.println(Thread.currentThread().getName()+"::"+Thread.currentThread().getState()+"::"+Thread.currentThread().getPriority());
        Thread_T_Priority th_t2=new Thread_T_Priority("T2", Thread.MIN_PRIORITY);
        System.out.println(Thread.currentThread().getName()+"::"+Thread.currentThread().getState()+"::"+Thread.currentThread().getPriority());
        Thread_T_Priority th_t3=new Thread_T_Priority("T3", Thread.NORM_PRIORITY);
        System.out.println(Thread.currentThread().getName()+"::"+Thread.currentThread().getState()+"::"+Thread.currentThread().getPriority());
	Thread_T_Priority th_t4=new Thread_T_Priority("T4",6);
        System.out.println(Thread.currentThread().getName()+"::"+Thread.currentThread().getState()+"::"+Thread.currentThread().getPriority());
    }
    
}
