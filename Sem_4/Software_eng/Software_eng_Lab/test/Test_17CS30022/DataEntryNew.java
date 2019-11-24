import java.util.ArrayList;

// Class methods and attributes defined according to the given data
class Employee
{
    private String empID, name;
    private double salary;

    public Employee(String empID, String name)
    {
        this.empID = empID;
        this.name = name;
    }

    public Employee(String empID, String name, double salary)
    {
        this.empID = empID;
        this.name = name;
        this.salary = salary;
    }

    /**
     * @return the empID
     */
    public String getEmpID() {
        return empID;
    }

    /**
     * @return the name
     */
    public String getName() {
        return name;
    }

    /**
     * @return the salary
     */
    public double getSalary() {
        return salary;
    }

    public void setSalary(double salary)
    {
        this.salary = salary;
    }
}

class Manager extends Employee
{
    private int subordinateCount;
    
    public Manager(String empID, String name)
    {
        // Calling the super class constructor as the name and empId are private
        super(empID, name);
    }

    public Manager(String empID, String name, double salary, int subordinateCount)
    {
        super(empID, name, salary);
        this.subordinateCount = subordinateCount;
    }

    /**
     * @return the subordinateCount
     */
    public int getSubordinateCount() {
        return subordinateCount;
    }

    public void setSubordinateCount(int subordinateCount)
    {
        this.subordinateCount = subordinateCount;
    }
}

class Programmer extends Employee
{
    private String programmingLanguage;
    private int experienceInYears;

    public Programmer(String empID, String name, double salary, String programmingLanguage, int experienceInYears)
    {
        super(empID, name, salary);
        this.programmingLanguage = programmingLanguage;
        this.experienceInYears = experienceInYears;
    }

    /**
     * @return the programmingLanguage
     */
    public String getProgrammingLanguage() {
        return programmingLanguage;
    }

    public void setProgrammingLanguage(String programmingLanguage)
    {
        this.programmingLanguage = programmingLanguage;
    }

    /**
     * @return the experienceInYears
     */
    public int getExperienceInYears() {
        return experienceInYears;
    }

    public void setExperienceInYears(int experienceInYears)
    {
        this.experienceInYears = experienceInYears;
    }
}

public class DataEntryNew
{
    static ArrayList<Employee> EmpList = new ArrayList<Employee>();
    
    // Setting the salary for each Manager according to the given formula
    static void setSalary(Manager obj)
    {
        int subordinateCount = obj.getSubordinateCount();
        double salary = Math.log(2 + subordinateCount) * 100000;
        obj.setSalary(salary);
    }

    // Incrementing the salary for only Java Programmers
    static void incrementSalary()
    {
        for(int i=0;i < EmpList.size();i++)
        {
            // If the object is of programmer type and has java programming language increase its salary by 5k
            if(Programmer.class.isInstance(EmpList.get(i)))
                if(((Programmer)(EmpList.get(i))).getProgrammingLanguage() == "Java")
                    EmpList.get(i).setSalary(35000);
        }
    }

    // Printing the details of the employee
    static void printEmp(Employee obj)
    {
        System.out.println("Name: "+obj.getName());
        System.out.println("Employee ID: "+obj.getEmpID());
        System.out.println("Salary: "+obj.getSalary());
        System.out.println("");
    }

    // Storing the object in the arraylist
    static void storeEmpRecord(Employee obj)
    {
        EmpList.add(obj);
    }

    // Displaying the object details in the arraylist
    static void displayEmpRecord()
    {
        for(int i=0;i < EmpList.size();i++)
            printEmp(EmpList.get(i));
    }
    public static void main(String[] args) {
        Manager man_obj1, man_obj2, man_obj3, man_obj4, man_obj5;
        Programmer prog_obj1, prog_obj2, prog_obj3, prog_obj4, prog_obj5;

        // Initialisng 5 programmers and manager objects with details
        man_obj1 = new Manager("Kousshik","17CS30022");
        man_obj1.setSubordinateCount(7);
        setSalary(man_obj1);

        man_obj2 = new Manager("Robin","17CS30023");
        man_obj2.setSubordinateCount(4);
        setSalary(man_obj2);

        man_obj3 = new Manager("Shivam","17CS30024");
        man_obj3.setSubordinateCount(3);
        setSalary(man_obj3);

        man_obj4 = new Manager("Naimesh","17CS30025");
        man_obj4.setSubordinateCount(2);
        setSalary(man_obj4);

        man_obj5 = new Manager("Snehal","17CS30026");
        man_obj5.setSubordinateCount(1);
        setSalary(man_obj5);

        
        prog_obj1 = new Programmer("Noob1","18CSKGP1", 30000, "Java", 1);
        prog_obj2 = new Programmer("Askan","18CSKGP2", 30000, "C", 2);
        prog_obj3 = new Programmer("Ashish","18CSKGP3", 30000, "Python", 3);
        prog_obj4 = new Programmer("Kamikaza","18CSKGP4", 30000, "Python", 4);
        prog_obj5 = new Programmer("Kakashi","18CSKGP5", 30000, "C", 5);

        // Storing them in the arraylist
        storeEmpRecord(man_obj1);
        storeEmpRecord(man_obj2);
        storeEmpRecord(man_obj3);
        storeEmpRecord(man_obj4);
        storeEmpRecord(man_obj5);
        storeEmpRecord(prog_obj1);
        storeEmpRecord(prog_obj2);
        storeEmpRecord(prog_obj3);
        storeEmpRecord(prog_obj4);
        storeEmpRecord(prog_obj5);

        // Incrementing salary for java programmers
        incrementSalary();

        // Displaying the details
        displayEmpRecord();
    }

}