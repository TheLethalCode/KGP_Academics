import java.util.Scanner;

public class BoxPolymorf
{
    // Accepts int and int as parameter
    public double area(int length,int breadth)
    {
        double area = length*breadth;
        return area;
    }

    // Accepts double and double as parameter
    public double area(double length,double breadth)
    {
        double area = length*breadth;
        return area;
    }

    // Accepts int and double as parameter
    public double area(int length,double breadth)
    {
        double area = length*breadth;
        return area;
    }

    // Accepts only int as parameter
    public double area(int side)
    {
        double area = side*side;
        return area;
    }

    // Accepts only double as parameter
    public double area(double side)
    {
        double area = side*side;
        return area;
    }

    // By changing the types and numbers of parameters we can overload the functions.
    public static void main(String args[])
    {
        // Printing area for the 5 Quadrilaterals
        BoxPolymorf box = new BoxPolymorf();
        System.out.println("The area of the quadrilateral using Method 1 is "+box.area(5,10));
        System.out.println("The area of the quadrilateral using Method 2 is "+box.area(5.5,10.5));
        System.out.println("The area of the quadrilateral using Method 3 is "+box.area(5,10.5));
        System.out.println("The area of the quadrilateral using Method 4 is "+box.area(10));
        System.out.println("The area of the quadrilateral using Method 5 is "+box.area(10.5));
    }
}
