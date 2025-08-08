namespace task2_c_
{
    internal class Program
    {
        static void Main(string[] args)
        {
           TheBank B1 = new TheBank();
           TheBank B2 = new TheBank("Ali","14725836914725","01007538841","CAL");
            B1.ShowAccountDetails();
            B2.ShowAccountDetails();
        }
    }
}
