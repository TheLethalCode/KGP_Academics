import java.util.Scanner;

class Animal
{
   String food;
   String eat()
   {
       return food;
   }        
}

class Dog extends Animal
{
    Dog()
    {
        food = "Meat";
    }
}    

class Cat extends Animal
{
    Cat()
    {
        food = "Mouse";
    }
}

class Elephant extends Animal
{
    Elephant()
    {
        food = "Grass";
    }
}

public class ViewAnimals
{
    public static void main(String args[])
    {
        Cat cat_obj = new Cat();
        Dog dog_obj = new Dog();
        Elephant elephant_obj = new Elephant();
        System.out.println("Dog eats: "+dog_obj.eat());
        System.out.println("Cat eats: "+cat_obj.eat());
        System.out.println("Elephant eats: "+elephant_obj.eat());       
    }
}
