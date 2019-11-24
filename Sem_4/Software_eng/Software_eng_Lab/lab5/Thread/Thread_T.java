public class Thread_T extends Thread{
	int time=0;
	
    public Thread_T(String name, int time) {
        super.setName(name);
		this.time=time;
        super.start();
    }

    @Override
    public void run(){
        for(int i=1;i<=10;i++){
            System.out.println(this.getName()+"::"+this.getPriority()+"::"+this.getState()+"::"+i);
            try {
                this.sleep(time);
            } catch (InterruptedException ex) {
                System.out.println("A inturrpt has occured!");
            }
        }
    }
    
    public static void main(String[] args) {
        Thread_T th_t1=new Thread_T("T1",50);
        System.out.println(Thread.currentThread().getName()+"::"+Thread.currentThread().getState()+"::"+Thread.currentThread().getPriority());
        Thread_T th_t2=new Thread_T("T2",50);
        System.out.println(Thread.currentThread().getName()+"::"+Thread.currentThread().getState()+"::"+Thread.currentThread().getPriority());
        Thread_T th_t3=new Thread_T("T3",50);
        System.out.println(Thread.currentThread().getName()+"::"+Thread.currentThread().getState()+"::"+Thread.currentThread().getPriority());
		Thread_T th_t4=new Thread_T("T4",50);
        System.out.println(Thread.currentThread().getName()+"::"+Thread.currentThread().getState()+"::"+Thread.currentThread().getPriority());
    }
    
}
