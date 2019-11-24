import java.util.Scanner;

class Data
{
    int data1,data2;
    Data()
    {
        data1=1;
        data2=2;
    }
}

class NewData extends Data
{
    int data3,data4;
    NewData()
    {
        data3=3;
        data4=4;
    }
}

public class Superclass
{   
    public static void main(String args[])
    {
        Data trys = new NewData();
        System.out.println("Data 1 = " + trys.data1);
        System.out.println("Data 2 = " + trys.data2);
        System.out.println("Data 3 = " + ((NewData)trys).data3);
        System.out.println("Data 4 = " + ((NewData)trys).data4);        
    }
}
