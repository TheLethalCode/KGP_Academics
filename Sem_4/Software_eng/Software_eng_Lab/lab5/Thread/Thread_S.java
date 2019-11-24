class Test{
	int val;
	Test(){
		val=0;
	}
	int add(){
		return val++;
	}
}
public class Thread_S extends Thread{
	int time=0;
	Test t;
	
    public Thread_S(String name, int time, Test t) {
        super.setName(name);
		this.t=t;
		this.time=time;
        super.start();
    }

    @Override
    public void run(){
        for(int i=1;i<=10;i++){
			synchronized(t){
				System.out.println(this.getName()+"::"+t.add());
			}
            /*try {
                this.sleep(time);
            } catch (InterruptedException ex) {
                System.out.println("A inturrpt has occured!");
            }*/
        }
    }
    
    public static void main(String[] args) {
		Test t=new Test();
        Thread_S th_t1=new Thread_S("T1",50,t);
		
        Thread_S th_t2=new Thread_S("T2",50,t);
		
        Thread_S th_t3=new Thread_S("T3",50,t);
		
		Thread_S th_t4=new Thread_S("T4",50,t);
    }
    
}
