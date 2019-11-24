import java.util.Scanner;

public class Factorial
{

    public static void main(String args[])
    {
        Scanner scan = new Scanner(System.in);
        System.out.println("Enter number:- ");
        int num = scan.nextInt();
        scan.close();
        long fact =1;
        for(int i=1;i<=num;i++)
            fact*=i;
        System.out.println("Factorial = " + fact);  
    }
}
