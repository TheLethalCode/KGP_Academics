class Bank
{
    protected float roi;
    float getRateOfInterest()
    {
        return roi;
    }
}

class SBI extends Bank
{
    SBI()
    {
        roi=(float)0.08;
    }
    @Override
    float getRateOfInterest() {
        return roi;
    }
}

class ICICI extends Bank
{
    ICICI()
    {
        roi=(float)0.07;
    }
    @Override
    float getRateOfInterest() {
        return roi;
    }
}

class AXIS extends Bank
{
    AXIS()
    {
        roi=(float)0.09;
    }
    @Override
    float getRateOfInterest() {
        return roi;
    }
}

public class Interest
{
    public static void main(String[] args) {
        SBI bank1 = new SBI();
        ICICI bank2 =  new ICICI();
        AXIS bank3 = new AXIS();
        System.out.println("SBI's rate of interest is "+bank1.getRateOfInterest());
        System.out.println("ICICI's rate of interest is "+bank2.getRateOfInterest());
        System.out.println("AXIS's rate of interest is "+bank3.getRateOfInterest());
    }
}