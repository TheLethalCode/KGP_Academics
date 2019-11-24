import java.util.Scanner;

class Account
{
        String name, acc_no, address, type;
        double balance;
        Account(String name,String acc_no,double balance)
        {
            this.name = name;
            this.acc_no = acc_no;
            this.balance = balance;
        }
        Account(String name, String acc_no, String address, String type, double balance)
        {
            this.name = name;
            this.address = address;
            this.type = type;
            this.acc_no = acc_no;
            this.balance = balance;
        }
        void Deposit(double x)
        {
            this.balance+=x;        
        }
        void Withdraw(double x)
        {
            this.balance-=x;        
        }
        double Get_Balance()
        {
            return this.balance;
        }
}

class AccessAccount extends Account
{
    AccessAccount(String name,String acc_no,double balance)
    {
        super(name,acc_no,balance);
    }
    AccessAccount(String name, String acc_no, String address, String type, double balance)
    {
        super(name,acc_no,address,type,balance);
    }
}

public class Overload
{   
    public static void main(String args[])
    {
        Account obj = new AccessAccount("Kousshik","8231231231",89120.12);
        System.out.println("Current balance = "+obj.Get_Balance());
        obj.Deposit(12000);
        System.out.println("Deposited = "+12000);
        System.out.println("Current balance = "+obj.Get_Balance());
    }
}
