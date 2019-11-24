import java.util.*;

public class strings
{
    public static void main(String[] args) {
        String name=new String("Kousshik Raj");
        int num_a=0;
        int length=name.length();
        Stack occur = new Stack();
        System.out.println("The length of the string is "+length);
        for(int i=0;i<length;i++)
        {
            if(name.charAt(i) == 'a' || name.charAt(i) == 'A')
            {
                num_a++;
                occur.push(i+1);
            }
        }
        System.out.println("The number of a's in the string are "+num_a);
        if(num_a > 0)
        {
            System.out.printf("They occur at position(s):- ");
            while(num_a-- > 0)
            {
                System.out.printf("%d ",occur.pop());
            }
        }
    }
}