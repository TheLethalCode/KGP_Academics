
// User defined Exception. All exceptions extends the exception class
class AttendanceException extends Exception
{

}

public class Attendance
{
    double percent;

    // Initialising percent attendance
    Attendance( double val )
    {
        percent = val;
    }

    // The check function to determine whether attendance has dropped below 40 percent
    void check() throws AttendanceException
    {
        if(percent < 40)
            throw new AttendanceException();
    }
    public static void main(String[] args) {
        Attendance obj1, obj2, obj3;

        // Creating three objects of attendance
        obj1 = new Attendance(85);
        obj2 = new Attendance(24);
        obj3 = new Attendance(38.4);

        // Catching if attendanceException is thrown for every object
        try {
            obj1.check();
            System.out.println("Object 1: Attendance is fine");
        } catch (AttendanceException e) {
            System.out.println("Object 1: Low Attendance");
        }

        try {
            obj2.check();
            System.out.println("Object 2: Attendance is fine");
        } catch (AttendanceException e) {
            System.out.println("Object 2: Low Attendance");
        }

        try {
            obj3.check();
            System.out.println("Object 3: Attendance is fine");
        } catch (AttendanceException e) {
            System.out.println("Object 3: Low Attendance");
        }
    }
}