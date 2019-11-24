import java.util.ArrayList;

// Defining members and attributes according to the given data
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
        // Since empID and name are private to super class
        super(empID, name);
    }

    public Manager(String empID, String name, double salary, int subordinateCount)
    {
        // Since empID and name are private to super class
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

public class DataEntry
{
    static ArrayList<Employee> EmpList = new ArrayList<Employee>();
    
    // Setting salary for a passed manager object
    static void setSalary(Manager obj)
    {
        int subordinateCount = obj.getSubordinateCount();
        double salary = Math.log(2 + subordinateCount) * 100000;
        obj.setSalary(salary);
    }

    // Printing the employee details for the employee
    static void printEmp(Employee obj)
    {
        System.out.println("Name: "+obj.getName());
        System.out.println("Employee ID: "+obj.getEmpID());
        System.out.println("Salary: "+obj.getSalary());
        System.out.println("");
    }

    // Storing the employee record in the arraylist
    static void storeEmpRecord(Employee obj)
    {
        EmpList.add(obj);
    }

    // Displaying the employee records stored in the arrayList
    static void displayEmpRecord()
    {
        for(int i=0;i < EmpList.size();i++)
            printEmp(EmpList.get(i));
    }
    public static void main(String[] args) {
        Manager man_obj1, man_obj2, man_obj3, man_obj4, man_obj5;
        Programmer prog_obj1, prog_obj2, prog_obj3, prog_obj4, prog_obj5;

        // Initialising 5 programmer objects and manager objects

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

        // Storing the objects
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

        // Displaying them
        displayEmpRecord();
    }

}