import java.util.Scanner;

public class ArrayError
{
    public static void main(String[] args) {
        try
        {
            int length;
            Scanner scan = new Scanner(System.in);
            System.out.printf("Enter the array size:- ");
            length = scan.nextInt();
            int arr[];
            arr = new int[length];
            System.out.printf("Enter the array elements:- ");
            for(int i=0;i<length;i++)
                arr[i] = scan.nextInt();
            
            System.out.println("The array elements are:- ");
            for(int i=0;i<length;i++)
                System.out.printf("%d ",arr[i]);

        }
        catch(NegativeArraySizeException ne)
        {
            System.out.println("Exception caught: "+ne);
        }
    }
}