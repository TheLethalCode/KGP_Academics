import java.util.Scanner;

class Account
{
    double bal;
    double getbal()
    {
        return bal;
    }
    void credit(double x)
    {
        bal+=x;
    }
    void debit(double x)
    {
        bal-=x;
    }
    Account(double x)
    {
        bal=x;
    }
}

public class Balance
{
    public static void main(String[] args) {
        Account user = new Account(1000);
        try
        {
            System.out.println("Enter the amount to withdraw:- ");
            Scanner scan = new Scanner(System.in);
            double withdraw = scan.nextDouble();
            if(user.getbal() < withdraw)
                throw new IllegalAccessException("Insufficient balance");
            user.debit(withdraw);
            System.out.println("Your current balance is "+user.getbal());
        }
        catch(IllegalAccessException e)
        {
            System.out.println("Error: "+e);
        }
    }
}