import java.util.*;

public class StackDemo
{
    public static void main(String[] args)
    {
        try
        {
            Stack stack= new Stack();
            stack.push(new Integer(10));
            stack.push("a");
            System.out.println("The contents of Stack is " + stack);
            System.out.println("The size of an Stack is " + stack.size());
            System.out.println("The number popped out is " + stack.pop());
            System.out.println("The number popped out is " + stack.pop());
            System.out.println("The number popped out is " + stack.pop());
            System.out.println("The content of Stack is " + stack);
            System.out.println("The size of an Stack is " + stack.size());
        }
        catch(EmptyStackException ae)
        {
            System.out.println("Exception caught: "+ae);
        }
    }
}