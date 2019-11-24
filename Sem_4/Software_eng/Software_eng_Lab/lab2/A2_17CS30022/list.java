import java.util.ArrayList;

public class list
{
    public static void main(String[] args) {
        ArrayList<Integer> arr = new ArrayList<>();
        for(int i=1;i<=10;i++)
            arr.add(i*i);
        int length = arr.size();
        
        System.out.println("The size of the list is "+length);
        System.out.println("The elements of the list are:- ");
        for(int i=0;i<length;i++)
            System.out.printf("%d ",arr.get(i));
        
        System.out.println("\nRemoving all elements ...");
        
        arr.clear();
        if(arr.isEmpty())
            System.out.println("The list is empty");
        else
            System.out.println("The list is not empty");
    }
}