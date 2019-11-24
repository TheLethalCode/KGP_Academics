import java.util.Scanner;

public class Prime
{
    
    public static boolean primec(int a)
    {
        if(a%2==0)
            return false;
        for(int i=3;i<=java.lang.Math.sqrt(a);i+=2)
        {
            if(a%i==0)
                return false;
        }
        return true;
    }    
    
    public static void main(String args[])
    {
        Scanner scan = new Scanner(System.in);
        System.out.printf("Enter left range:- ");
        int left = scan.nextInt();
        System.out.printf("Enter right range:- ");
        int right = scan.nextInt();
        scan.close();
        System.out.println("The prime numbers in the range are:- ");  
        for(int i=left;i<=right;i++)
            if(primec(i))
                System.out.printf("%d ",i);
        System.out.println();  
    }
}
