import java.util.Scanner;

public class Squares
{
    public static void main(String args[])
    {
        Scanner scan = new Scanner(System.in);
        System.out.printf("Enter number of elements:- ");
        int num = scan.nextInt();
        int array[];
        array = new int[num];
        System.out.printf("Enter the elements:- ");
        for(int i=0;i<num;i++)
            array[i] = scan.nextInt();
        
        long ans = 0;
        for(int i=0;i<num;i++)
            ans+=array[i]*array[i];
        System.out.printf("The sum of squares = %d %n",ans);
    }
}
