public class ComputeInitials
{
    public static void main(String[] args) {
        String myName="Fred F. Flintstone";
        String myInitials=new String();
        int length=myName.length();

        for(int i=0;i<length;i++)
        {
            if(Character.isUpperCase(myName.charAt(i)))
            {
                myInitials += myName.charAt(i);
            }
        }
        System.out.println("My Initials are: "+myInitials);
    }    
}